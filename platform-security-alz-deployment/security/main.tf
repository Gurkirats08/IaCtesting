data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "storage_account" {
  name                = var.storageAccounts["stg2"].name
  resource_group_name = var.storageAccounts["stg2"].resource_group_name
  depends_on          = [module.storage_account]
}


#Multiple RG's
module "resource_group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcegroup\\v1.0"
  location            = each.value.location
  resource_group_name = each.value.name
  tags                = each.value.tags
}

#Resource Locks
module "security_resource_lock" {
  for_each            = var.securityResourceLocks
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcelock\\v1.0"
  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  lock_level          = each.value.lock_level
  notes               = each.value.notes
  resource_name       = each.value.resource_name
  resource_type       = each.value.resource_type
  subscription_id     = data.azurerm_client_config.current.subscription_id
  depends_on          = [module.resource_group, null_resource.vm_start]
}

#-----------------------------------------------------------------------------------
# Network Resources

# secectivity NSGs
module "sec_nsg_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\networksecuritygroup\\v1.0"
  main_location           = var.mainLocation
  environment             = var.environment
  network_security_groups = var.secNetworkSecurityGroups
  depends_on = [
    module.resource_group
  ]
}

#ddos plan
module "ddos_plan_module" {
  source        = "..\\..\\terraform-modules-hub\\terraform-modules\\ddos\\v1.0"
  main_location = var.mainLocation
  environment   = var.environment
  ddos_plans    = var.SecurityDDos
  depends_on    = [module.resource_group]
}


# virtual networks
module "sec_vnet_module" {
  for_each                     = var.secVirtualNetworks
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\virtualnetwork\\v1.0"
  virtual_network_name         = each.value.VirtualNetworkName
  resource_group_name          = each.value.resourceGroupName
  location                     = var.mainLocation
  address_space                = [each.value.address_space]
  ddos_protection_plan_ddos_id = module.ddos_plan_module.ddos_protection_plan_ids[each.value.DDosProtectionPlan]
  tags                         = { environment = var.environment }
  depends_on                   = [module.resource_group]
}

# subnets
module "sec_subnet_module" {
  for_each                  = var.secSubnets
  source                    = "..\\..\\terraform-modules-hub\\terraform-modules\\subnet\\v1.0"
  resource_group_name       = each.value.resourceGroupName
  virtual_network_name      = each.value.vnet_name
  subnet_name               = each.value.name
  address_prefixes          = [each.value.addressPrefix]
  route_table_id            = each.value.routeTableId
  network_security_group_id = each.value.nsgName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.nsgName}"
  service_endpoints         = ["Microsoft.KeyVault"]
  depends_on                = [module.resource_group, module.sec_vnet_module, module.sec_nsg_module, module.sec_route_table_module]
}

module "sec_route_table_module" {
  for_each            = var.secRouteTables
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\routetable\\v1.0"
  resource_group_name = each.value.resourceGroupName
  route_table_name    = each.value.routeTableName
  location            = var.mainLocation
  tags                = { environment = var.environment }
  route_table = {
    bgp_route_propagation_enabled = each.value.enableBgpRoutePropagation
    routes                        = each.value.routes
  }
  depends_on = [module.resource_group]
}

#------------------------------------------------------------------------------------
# Management Resources

module "sec_log_analytics_workspace_module" {
  source     = "..\\..\\terraform-modules-hub\\terraform-modules\\loganalytics\\v1.0"
  workspaces = var.secWorkspace
  location   = var.mainLocation
  depends_on = [module.resource_group]
}

module "data_collection_endpoint" {
  for_each                      = var.securitydatacollectionendpoint
  source                        = "..\\..\\terraform-modules-hub\\terraform-modules\\datacollectionendpoint\\v1.0"
  name                          = each.value.datacollectionendpoint
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  kind                          = each.value.kind
  public_network_access_enabled = false
  depends_on                    = [module.resource_group]
}

# associate resource to a Data Collection Endpoint
resource "azurerm_monitor_data_collection_rule_association" "Association" {
  for_each                    = var.dce_resource_association
  target_resource_id          = each.value.target_resource_id
  data_collection_endpoint_id = module.data_collection_endpoint[each.value.datacollectionendpoint].id
  depends_on                  = [module.data_collection_endpoint]
}

module "data_collection_rule" {
  for_each = var.dcr_configs
  source   = "..\\..\\terraform-modules-hub\\terraform-modules\\datacollectionrule\\v1.0"

  dcr_name                 = each.value.dcr_name
  dcr_rg_name              = each.value.dcr_rg_name
  dcr_rg_location          = each.value.dcr_rg_location
  dce_name                 = each.value.dce_name
  dce_rg_name              = each.value.dce_rg_name
  law_name                 = var.secWorkspace["law1"].name
  law_rg_name              = var.resourceGroups["mgmtRG"].name
  destination_logworkspace = each.value.destination_logworkspace
  data_flow_streams        = each.value.data_flow_streams

  # Windows-specific data sources
  os_type                          = each.value.os_type
  datasource_perfcounter           = each.value.datasource_perfcounter
  datasource_perfCounterSpecifiers = each.value.datasource_perfCounterSpecifiers
  win_perfcounter_name             = each.value.win_perfcounter_name
  win_event_log_stream             = each.value.win_event_log_stream
  win_path_Query                   = each.value.win_path_Query
  win_log_name                     = each.value.win_log_name

  # Linux-specific data sources
  linux_log_name         = each.value.linux_log_name
  linux_event_log_stream = each.value.linux_event_log_stream


  tags       = each.value.tags
  depends_on = [module.data_collection_endpoint, module.sec_log_analytics_workspace_module]
}


#-------------------------------------------------------------------------------------
#Backup Resources RG

#Backup Vault with immutable parameter
resource "null_resource" "backup_vault" {
  provisioner "local-exec" {
    command = <<EOT

    az config set extension.dynamic_install_allow_preview=true

    keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.connHSM.name} --name ${var.hsm_key_name}  --query [key.kid] -o tsv)

    az dataprotection backup-vault create --vault-name ${var.backupVaultName} --resource-group ${var.resourceGroups["backupRG"].name} --location ${var.mainLocation} --storage-setting "[{type:'LocallyRedundant',datastore-type:'VaultStore'}]" --type "SystemAssigned,UserAssigned" --user-assigned-identities '{"/subscriptions/${var.subscriptionId}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.securityuan}":{}}' --cmk-encryption-key-uri $keyVaultKeyUrl --cmk-encryption-state "Enabled" --cmk-identity-type "UserAssigned" --cmk-infrastructure-encryption "Enabled" --cmk-user-assigned-identity-id  "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.securityuan}" --immutability-state Locked
    EOT
  }
  #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [triggers]
  # }
  depends_on = [null_resource.des, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User]

}

module "sec_storage_backuppolicy_module" {
  source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\storagebackuppolicy\\v1.0"
  for_each                         = var.storagebackupPolicies
  backup_policy_name               = each.value.backup_policy_name
  backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.sec_sub_id}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
  vault_default_retention_duration = each.value.vault_default_retention_duration
  backup_instance_name             = each.value.backup_instance_name
  location                         = each.value.location
  storage_account_id               = local.storage_account_id
  backupvaultname                  = each.value.backup_vault_Name
  resource_group_name              = each.value.resource_group_name
  depends_on                       = [module.resource_group, module.sec_backupvault_module, module.storage_account]
}

module "sec_disk_backup_polcy_module" {
  source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\diskbackuppolicy\\v1.0"
  for_each                         = var.diskBackupPolicies
  location                         = each.value.location
  backup_policy_name               = each.value.backup_policy_name
  backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
  backupvaultname                  = each.value.backup_vault_Name
  backupvault_resource_group_name  = each.value.backupvault_resource_group_name
  managed_disk_name                = "${each.value.vmName}-${each.value.osType}"
  managed_disk_resource_group_name = each.value.managed_disk_resource_group_name
  snapshot_resource_group_name     = each.value.snapshot_resource_group_name
  backup_instance_name             = each.value.backup_instance_name
  depends_on                       = [module.sec_backupvault_module, module.resource_group, module.jumpbox_vm_module]

}

#--------------------------------------------------------------------------------
# Common Resources



# ACC Intergartion------------------

module "sec_user_assigned_identity" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
  name                = var.securityuan
  location            = var.mainLocation
  resource_group_name = var.resourceGroups["commonRG"].name
  depends_on          = [module.resource_group]
}

# HSM Integration

data "azurerm_key_vault_managed_hardware_security_module" "hsm" {
  provider            = azurerm.securitySub
  name                = var.connHSM.name
  resource_group_name = var.connHSM.resource_group_name
}

module "hsm_private_endpoint" {
  for_each                       = var.hsmPrivateEndpoint
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\privateendpoint\\v1.0"
  private_endpoint_name          = each.value.private_endpoint_name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  subnet_id                      = module.sec_subnet_module[each.value.subnet_id].id
  private_dns_zone_id            = each.value.private_dns_zone_id
  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  depends_on                     = [module.sec_subnet_module, module.azurerm_private_dns_zone_virtual_network_link] 
}

# # Rbac for disk on HSM
resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "HSM_Crypto_Service_Encryption_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys"
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/33413926-3206-4cdd-b39a-83574fe37a17"
  principal_id       = module.sec_user_assigned_identity.principal_id
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }
  depends_on = [module.hsm_private_endpoint,module.sec_user_assigned_identity, data.azurerm_key_vault_managed_hardware_security_module.hsm]
}

resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "Managed_HSM_Crypto_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys"
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b"
  principal_id       = module.sec_user_assigned_identity.principal_id
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }
  depends_on = [module.hsm_private_endpoint,module.sec_user_assigned_identity, data.azurerm_key_vault_managed_hardware_security_module.hsm]
}

locals {
  user_assigned_identity_id = module.sec_user_assigned_identity.id
  disk_encryption_set_id    = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resourceGroups["commonRG"].name}/providers/Microsoft.Compute/diskEncryptionSets/${var.secDiskEncryptionSet["sec-team"].disk_encryption_set_name}"
  depends_on                = [module.sec_user_assigned_identity]
}

# CLI command for HSM key and Disk Encryption Set
resource "null_resource" "des" {

  #Use trigger block during development then after the key is created, comment out trigger and uncomment the lifecycle block to avoid the null resource to run everytime
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "chmod +x scriptdes.ps1"
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-File"]
    command     = "scriptdes.ps1"
  }

  depends_on = [module.hsm_private_endpoint,resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
}


# # Jumpbox VM module
module "jumpbox_vm_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\windowsvm\\v1.0-acc"
  location                = var.mainLocation
  administrator_user_name = var.adminUser
  windows_vms             = var.secJumpBoxVms
  identity_type           = "UserAssigned"
  identity_ids            = module.sec_user_assigned_identity.id
  disk_encryption_set_id  = local.disk_encryption_set_id
  depends_on              = [module.sec_vnet_module, module.sec_subnet_module, module.resource_group, local.disk_encryption_set_id]
}

# # #Deallocating the VM------------------

resource "null_resource" "deallocation" {
  for_each = { for vm in var.secJumpBoxVms : vm.vmName => vm }
  provisioner "local-exec" {
    command = "az vm deallocate --resource-group ${each.value.resourceGroupName} --name ${each.value.vmName} --subscription ${var.subscriptionId}"
  }
  #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [triggers]
  # }
  depends_on = [module.windows_guest_attestation, module.jumpbox_vm_module, module.antimalware_vm_extension_module, module.diagnostic_setting_vm_extension_module, module.azurerm_virtual_machine_extension_daagent] //,module.azurerm_virtual_machine_extension_gc]
}

# # #Enabling encryption on the VM -----------------

resource "null_resource" "encryptionAtHost" {
  for_each = { for vm in var.secJumpBoxVms : vm.vmName => vm }
  provisioner "local-exec" {
    command = "az vm update -n ${each.value.vmName} -g ${each.value.resourceGroupName} --set securityProfile.encryptionAtHost=true --subscription ${var.subscriptionId}"
  }
  #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [triggers]
  # }
  depends_on = [null_resource.deallocation]
}

# # Starting the VM again after enabling encryption-------------

resource "null_resource" "vm_start" {
  for_each = { for vm in var.secJumpBoxVms : vm.vmName => vm }
  provisioner "local-exec" {
    command = "az vm start --resource-group ${each.value.resourceGroupName} --name ${each.value.vmName} --subscription ${var.subscriptionId}"
  }
  #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [triggers]
  # }
  depends_on = [null_resource.encryptionAtHost]
}

# # allow all aproach
# # Antimalware extension for VMkey
module "antimalware_vm_extension_module" {
  source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
  for_each                   = var.secJumpBoxVms
  resource_group_name        = each.value.resourceGroupName
  name                       = "IaaSAntimalware"
  virtual_machine_name       = each.value.vmName
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
  settings                   = <<SETTINGS
  {
      "AntimalwareEnabled": "true",
      "RealtimeProtectionEnabled": "true",
      "ScheduledScanSettings": {
        "isEnabled": "true",
        "day": "7",
        "time": "120",
        "scanType": "Quick"
      }
  }
  SETTINGS
  protected_settings         = lookup(each.value, "protected_settings", null)
  depends_on                 = [module.jumpbox_vm_module, module.resource_group]
  tags                       = { "environment" : var.environment }
}

# # allow all aproach
# # DiagnosticSetting extension for VM
module "diagnostic_setting_vm_extension_module" {
  source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
  for_each                   = var.secJumpBoxVms
  resource_group_name        = each.value.resourceGroupName
  name                       = "Microsoft.Insights.VMDiagnosticsSettings"
  virtual_machine_name       = each.value.vmName
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
  settings                   = <<SETTINGS
    {
        "StorageAccount": "${data.azurerm_storage_account.storage_account.name}",
        "WadCfg": {
          "DiagnosticMonitorConfiguration": {
            "Metrics": {
              "resourceId": "/${each.value.subscriptionId}/resourceGroups/${each.value.resourceGroupName}/providers/Microsoft.Compute/virtualMachines/${each.value.vmName}"
            }
          }
        }
    }
  SETTINGS
  protected_settings         = <<SETTINGS
  {
    "storageAccountName": "${data.azurerm_storage_account.storage_account.name}",
    "storageAccountKey": "${data.azurerm_storage_account.storage_account.primary_access_key}",
    "storageAccountEndPoint": "https://${data.azurerm_storage_account.storage_account.primary_blob_endpoint}"
  }
  SETTINGS
  depends_on                 = [module.jumpbox_vm_module, module.resource_group]
  tags                       = { "environment" : var.environment }
}

module "azurerm_virtual_machine_extension_daagent" {
  source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
  for_each                   = var.secJumpBoxVms
  resource_group_name        = each.value.resourceGroupName
  name                       = "DependencyAgentWindows"
  virtual_machine_name       = each.value.vmName
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.9"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
  protected_settings         = lookup(each.value, "protected_settings", null)
  depends_on                 = [module.jumpbox_vm_module]
  tags                       = { "environment" : var.environment }
}

module "windows_guest_attestation" {
  source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
  for_each                   = var.secJumpBoxVms
  resource_group_name        = each.value.resourceGroupName
  name                       = "GuestAttestation"
  virtual_machine_name       = each.value.vmName
  publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
  type                       = "GuestAttestation"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  depends_on                 = [module.jumpbox_vm_module]
}

# ACC Intergration------------------




module "storage_account" {
  for_each                        = var.storageAccounts
  source                          = "..\\..\\terraform-modules-hub\\terraform-modules\\storageaccount\\v1.0"
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  name                            = each.value.name
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  key_vault_key_id                = "https://${var.connHSM.name}.managedhsm.azure.net/keys/${var.hsm_key_name}"
  user_assigned_identity_id       = module.sec_user_assigned_identity.id
  identity_type                   = "UserAssigned"
  queue_encryption_key_type       = "Account"
  table_encryption_key_type       = "Account"
  identity_ids                    = [module.sec_user_assigned_identity.id]
  depends_on                      = [module.resource_group, module.sec_user_assigned_identity, null_resource.des, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User]
}

# network Watcher - can be tested only after the network watcher is enabled in each subscription
data "azurerm_network_watcher" "sec_network_watcher_module" {
  name                = var.network_watcher_name
  resource_group_name = var.network_watcher_rg
}

locals {
  storage_account_id = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.nsgFlowstorageAccountResourceGroupName}/providers/Microsoft.Storage/storageAccounts/${var.nsgFlowstorageAccountName}"
}


# # mgmt NSG flow logs - can be tested only after the network watcher is enabled in each subscription
module "sec_nsg_flow_logs_module" {
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\nsgflowlogs\\v1.0"
  network_watcher_name         = data.azurerm_network_watcher.sec_network_watcher_module.name
  resource_group_name          = data.azurerm_network_watcher.sec_network_watcher_module.resource_group_name
  nsg_flow_log_name            = var.connFlowLog.nsg_flow_log_name
  location                     = var.connFlowLog.location
  nsg_id                       = var.connFlowLog.nsgId
  storage_account_id           = local.storage_account_id
  log_analytics_workspace_name = var.secWorkspace["law1"].name
  log_analytics_resource_group = var.secWorkspace["law1"].resourceGroupName
  depends_on                   = [data.azurerm_network_watcher.sec_network_watcher_module, module.resource_group, module.storage_account, module.sec_log_analytics_workspace_module]
}


#---------------------------------------------------------------------------------------
#Security Resources

module "sec_private_endpoint_module" {
  for_each                       = var.secPrivateEndpoint
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\privateendpoint\\v1.0"
  private_endpoint_name          = each.value.private_endpoint_name
  resource_group_name            = each.value.resource_group_name
  location                       = var.mainLocation
  subnet_id                      = module.sec_subnet_module[each.value.subnet_id].id
  private_dns_zone_id            = each.value.private_dns_zone_id
  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  depends_on                     = [module.sec_subnet_module, module.storage_account, module.sec_keyvault_module]

}

# keyvault for secectivity resource groups
module "sec_keyvault_module" {
  for_each                    = var.secKeyVaults
  source                      = "..\\..\\terraform-modules-hub\\terraform-modules\\keyvault\\v1.0"
  key_vault_location          = var.mainLocation
  resource_group_name         = var.resourceGroups["secRG"].name
  sku_name                    = each.value.sku
  key_vault_name              = each.value.name
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  # public_network_access_enabled = false
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  log_analytics_workspace_id = module.sec_log_analytics_workspace_module.law_id_map[var.secWorkspace["law1"].name]
  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [module.sec_subnet_module["vnet-sao-sec-aen-001_gatewaysubnet"].id, module.sec_subnet_module["vnet-sao-sec-aen-001_AzureFirewallSubnet"].id, module.sec_subnet_module["vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01"].id, module.sec_subnet_module["vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-02"].id, module.sec_subnet_module["vnet-sao-sec-aen-001_AzureBastionSubnet"].id, "/subscriptions/6c55b3c2-3d8e-40e8-85cf-a95d842095ac/resourceGroups/Contos-ADO-Runners/providers/Microsoft.Network/virtualNetworks/Contos-ADO-Runners-vnet/subnets/default"]
  }
  depends_on = [module.resource_group, module.sec_log_analytics_workspace_module]
}

resource "time_sleep" "wait_kv" {
  depends_on = [module.sec_keyvault_module]

  create_duration = "120s"
}

module "rbac" {
  for_each             = var.secRbacs
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
  scope                = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["secRG"].name}/providers/${each.value.provider}/${each.value.resource_type}/${each.value.resource_name}"
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Reader"
  depends_on           = [module.sec_keyvault_module]
}

module "rbac1" {
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
  scope                = module.sec_keyvault_module["kv1"].key_vault_id
  principal_id         = module.sec_user_assigned_identity.principal_id
  role_definition_name = "Key Vault Crypto User"
  depends_on           = [module.sec_user_assigned_identity, module.sec_keyvault_module]
}

module "rbac3" {
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
  scope                = module.sec_keyvault_module["kv1"].key_vault_id
  principal_id         = module.sec_user_assigned_identity.principal_id
  role_definition_name = "Key Vault Secrets Officer"
  depends_on           = [module.sec_user_assigned_identity, module.sec_keyvault_module]
}

module "rbac5" {
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
  scope                = module.sec_keyvault_module["kv1"].key_vault_id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  depends_on           = [module.sec_user_assigned_identity, module.sec_keyvault_module]
}

module "rbac6" {
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
  scope                = module.sec_keyvault_module["kv1"].key_vault_id
  principal_id         = module.sec_user_assigned_identity.principal_id
  role_definition_name = "Key Vault Crypto User"
  depends_on           = [module.sec_user_assigned_identity]
}

resource "time_sleep" "wait_rbac" {
  depends_on = [module.rbac5]

  create_duration = "120s"
}

module "azurerm_key_vault_key" {
  source             = "..\\..\\terraform-modules-hub\\terraform-modules\\keyvaultkey\\v1.0"
  key_vault_key_name = var.key_vault_key_name
  key_vault_id       = module.sec_keyvault_module["kv1"].key_vault_id
  key_type           = "RSA"
  key_size           = 2048
  expiration_date    = "2026-01-01T00:00:00Z"
  depends_on = [
  module.sec_keyvault_module, module.resource_group, module.rbac5, resource.time_sleep.wait_rbac, module.sec_private_endpoint_module]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy = {
    time_before_expiry   = "P30D"
    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

}





#----------------------------------------------------------------------------------------

#network resources

module "sec_network_peering" {
  source = "..\\..\\terraform-modules-hub\\terraform-modules\\peering\\v1.0"
  providers = {
    azurerm.source = azurerm.SecuritySub
    azurerm.dest   = azurerm.connSub
  }
  for_each            = var.secVnetPeering
  sourceVnetName      = each.value.sourceVnetName
  sourceVnetRg        = each.value.sourceVnetRg
  destinationVnetName = each.value.destinationVnetName
  destinationVnetRg   = each.value.destinationVnetRg
  depends_on          = [module.sec_vnet_module]
}


module "azurerm_private_dns_zone_virtual_network_link" {
  source = "..\\..\\terraform-modules-hub\\terraform-modules\\privatednszonevirtualnetworklink\\v1.0"
  providers = {
    azurerm = azurerm.connSub
  }
  for_each             = var.secDNSLink
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  private_dns_zone     = each.value.private_dns_zone_name
  virtual_network_id   = module.sec_vnet_module["vnet-sao-sec-aen-001"].id
  registration_enabled = each.value.registration_enabled
  depends_on           = [module.sec_vnet_module]
}

#------------------------------------------------------------------------

##RSV module
module "sec_recovery_service_vault" {
  for_each                     = var.secRecoveryServiceVault
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\recoveryservicevault"
  recovery_services_vault_name = each.value.recovery_services_vault_name
  location                     = var.mainLocation
  resource_group_name          = each.value.resource_group_name
  sku                          = each.value.sku
  identity_type                = each.value.identity_type
  identity_ids                 = [module.sec_user_assigned_identity.id]
  depends_on                   = [module.resource_group, module.sec_user_assigned_identity]
}

locals {
  encryption_key_id = "https://${var.connHSM.name}.managedhsm.azure.net/keys/${var.hsm_key_name}"
  rsv_name          = var.secRecoveryServiceVault["rsv1"].recovery_services_vault_name
}

resource "null_resource" "rsv_encryption" {
  provisioner "local-exec" {
    command = "az backup vault encryption update --encryption-key-id ${local.encryption_key_id} --mi-user-assigned ${local.user_assigned_identity_id} --resource-group ${var.rsv_rg} --name ${local.rsv_name} --infrastructure-encryption Enabled"
  }
  lifecycle {
    ignore_changes = [triggers]
  }
  depends_on = [null_resource.des, module.sec_recovery_service_vault, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]

}

# #VM Backup policy
module "vm_backup_policy_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\vmbackuppolicy\\v1.0"
  for_each                = var.vm_backup_policies
  backup_policy_name      = each.value.backup_policy_name
  recovery_vault_name     = each.value.recovery_vault_name
  rsv_resource_group_name = each.value.rsv_resource_group_name
  backup_frequency        = each.value.backup_frequency
  backup_time             = each.value.backup_time
  retention_daily_count   = each.value.retention_daily_count
  vm_name                 = each.value.vm_name
  vm_resource_group_name  = each.value.vm_resource_group_name
  depends_on              = [module.sec_recovery_service_vault, module.jumpbox_vm_module]
}

# #diagnostics logs
module "diagnostic_setting" {
  for_each                       = var.diagnostic_logs
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\diagnosticlogs"
  name                           = each.value.name
  target_resource_id             = each.value.target_resource_id
  storage_account_id             = each.value.storage_account_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  eventhub_name                  = each.value.eventhub_name
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  logs_categories                = each.value.logs_categories
  metrics                        = each.value.metrics
  depends_on                     = [module.storage_account]
}










