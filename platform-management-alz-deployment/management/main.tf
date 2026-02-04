data "azurerm_client_config" "current" {}

# Multiple Resource Group
module "resource_group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcegroup\\v1.0"
  location            = each.value.location
  resource_group_name = each.value.name
  tags                = each.value.tags
}

# mgmt Resource Locks
module "mgmt_resource_lock" {
  for_each            = var.mgmtResourceLocks
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcelock\\v1.0"
  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  lock_level          = each.value.lock_level
  notes               = each.value.notes
  resource_name       = each.value.resource_name
  resource_type       = each.value.resource_type
  subscription_id     = data.azurerm_client_config.current.subscription_id
  depends_on          = [module.resource_group]
}

#----------------------------------------------------------------
#Network resources in Network RG 

# mgmt NSGs
module "mgmt_nsg_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\networksecuritygroup\\v1.0"
  main_location           = var.mainLocation
  environment             = var.environment
  network_security_groups = var.mgmtNetworkSecurityGroups
  depends_on = [
    module.resource_group
  ]
}


module "mgmt_backup"{
  source = "C:\\Users\\gurksingh\\OneDrive - Microsoft\\Desktop\\philips\\DevOps\\terraform-modules\\backupvault"
  backupvaultname = var.mgmtBackupVaultName
  resource_group_name = var.commonResourceGroupName
  location = var.mainLocation
  redundancy = "LocallyRedundant"
  datastore_type = "VaultStore"
}


# mgmt ddos plan
module "mgmt_ddosplan_module" {
  source        = "..\\..\\terraform-modules-hub\\terraform-modules\\ddos\\v1.0"
  main_location = var.mainLocation
  environment   = var.environment
  ddos_plans    = var.mgmtddos
  depends_on    = [module.resource_group]
}

# mgmt virtual networks
module "mgmt_vnet_module" {
  for_each                     = var.mgmtVirtualNetworks
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\virtualnetwork\\v1.0"
  virtual_network_name         = each.value.VirtualNetworkName
  resource_group_name          = each.value.resourceGroupName
  location                     = var.mainLocation
  address_space                = [each.value.address_space]
  ddos_protection_plan_ddos_id = module.mgmt_ddosplan_module.ddos_protection_plan_ids[each.value.DDosProtectionPlan]
  tags                         = { "environment" : var.environment }
  depends_on                   = [module.resource_group, module.mgmt_ddosplan_module]
}

# mgmt subnets
module "mgmt_subnet_module" {
  for_each                          = var.mgmtSubnets
  source                            = "..\\..\\terraform-modules-hub\\terraform-modules\\subnet\\v1.0"
  resource_group_name               = each.value.resourceGroupName
  virtual_network_name              = each.value.vnet_name
  subnet_name                       = each.value.name
  address_prefixes                  = [each.value.addressPrefix]
  route_table_id                    = each.value.rtName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/routeTables/${each.value.rtName}" #each.value.routeTableId
  private_endpoint_network_policies = var.private_endpoint_network_policies
  network_security_group_id         = each.value.nsgName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.nsgName}"
  depends_on                        = [module.resource_group, module.mgmt_vnet_module, module.mgmt_nsg_module, module.mgmt_route_table_module]
}

# route table mgmt
module "mgmt_route_table_module" {
  for_each            = var.mgmtRouteTables
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\routetable\\v1.0"
  resource_group_name = each.value.resourceGroupName
  route_table_name    = each.value.routeTableName
  location            = var.mainLocation
  tags                = { "environment" : var.environment }
  route_table = {
    bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
    routes                        = each.value.routes
  }
  depends_on = [module.resource_group]
}

# mgmt Network Peering
module "mgmt_network_peering" {
  source = "..\\..\\terraform-modules-hub\\terraform-modules\\peering\\v1.0"
  providers = {
    azurerm.source = azurerm.mgmtSub
    azurerm.dest   = azurerm.connSub
  }
  for_each                  = var.mgmtNetworkPeering
  sourceVnetName            = each.value.sourceVnetName
  sourceVnetRg              = each.value.sourceVnetRg
  destinationVnetName       = each.value.destinationVnetName
  destinationVnetRg         = each.value.destinationVnetRg
  remote_virtual_network_id = null
  allowVirtualNetworkAccess = "true"
  allowForwardedTraffic     = "true"
  allowGatewayTransit       = "false"
  useRemoteGateways         = "false"
  depends_on                = [module.mgmt_vnet_module]
}


# mgmt Private DNS Link
module "mgmt_pvt_dns_link" {
  source = "..\\..\\terraform-modules-hub\\terraform-modules\\privatednszonevirtualnetworklink\\v1.0"
  providers = {
    azurerm = azurerm.connSub
  }
  for_each             = var.mgmtDNSLink
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  private_dns_zone     = each.value.private_dns_zone_name
  virtual_network_id   = module.mgmt_vnet_module["vnet-sao-mgmt-aen-001"].id
  registration_enabled = each.value.registration_enabled
  depends_on           = [module.mgmt_vnet_module]
}

#-----------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------
# # Remaining Resources in common Rg

# mgmt user assigned identity
module "mgmt_user_assigned_identity" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
  for_each            = var.userAssignedIdentityName
  name                = each.value.uai_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  depends_on          = [module.resource_group, module.mgmt_pvt_dns_link, module.mgmt_route_table_module] #module.mgmt_network_peering,
}

# Referring HSM from security subscription
data "azurerm_key_vault_managed_hardware_security_module" "hsm" {
  provider            = azurerm.securitySub
  name                = var.HSM.name
  resource_group_name = var.HSM.hsm_rg_name
}

resource "azurerm_key_vault_managed_hardware_security_module_key" "hsm-key" {
  provider        = azurerm.securitySub
  managed_hsm_id  = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name            = var.hsm_key_name
  key_type        = "RSA-HSM"
  key_size        = 2048
  key_opts        = ["sign", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify"]
  expiration_date = "2026-09-19T23:59:59Z"
  not_before_date = "2024-09-20T00:00:00Z"
  depends_on      = [data.azurerm_key_vault_managed_hardware_security_module.hsm]
}

# RBACs on HSM for mgmt user assigned identity
resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "HSM_Crypto_Service_Encryption_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys/${var.hsm_key_name}" ## assign to dedicated key
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/33413926-3206-4cdd-b39a-83574fe37a17"
  principal_id       = module.mgmt_user_assigned_identity["uai1"].principal_id
  depends_on         = [module.mgmt_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }
}

resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "Managed_HSM_Crypto_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys/${var.hsm_key_name}" ## assign to dedicated key
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b"
  principal_id       = module.mgmt_user_assigned_identity["uai1"].principal_id
  depends_on         = [module.mgmt_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }
}

resource "azurerm_key_vault_managed_hardware_security_module_key_rotation_policy" "hsm-key-rotation-policy" {
  managed_hsm_key_id = azurerm_key_vault_managed_hardware_security_module_key.hsm-key.id
  expire_after       = "P730D" # 2 years 
  time_before_expiry = "P30D"  # 30 days before expiry
  #Uncomment lifecycle block after development in next run to avoid to running everytime
  #lifecycle {
  #   ignore_changes = [
  #     id, managed_hsm_key_id
  #   ]
  # }
  depends_on = [resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
}




# # mgmt Storage Sccount
module "mgmt_storage_account" {
  source                        = "..\\..\\terraform-modules-hub\\terraform-modules\\storageaccount\\v1.0"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  resource_group_name           = var.commonResourceGroupName
  location                      = var.mainLocation
  name                          = var.nsgFlowStorageAccountName
  key_vault_key_id              = resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key.id
  user_assigned_identity_id     = module.mgmt_user_assigned_identity["uai1"].id
  identity_type                 = "UserAssigned"
  identity_ids                  = [module.mgmt_user_assigned_identity["uai1"].id]
  public_network_access_enabled = false
  shared_access_key_enabled     = false
  queue_encryption_key_type     = "Account"
  table_encryption_key_type     = "Account"
  depends_on                    = [module.mgmt_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key, module.resource_group, azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
}

# mgmt Backup Vault for backing up storage account

#Backup Vault with immutable parameter
resource "null_resource" "backup_vault" {
  provisioner "local-exec" {
    command = <<EOT

    az config set extension.dynamic_install_allow_preview=true

    keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.HSM.name} --name ${var.hsm_key_name}  --query [key.kid] -o tsv)

    az dataprotection backup-vault create --vault-name ${var.backupVaultName} --resource-group ${var.resourceGroups["backupRG"].name} --location ${var.mainLocation} --storage-setting "[{type:'LocallyRedundant',datastore-type:'VaultStore'}]" --type "SystemAssigned,UserAssigned" --user-assigned-identities '{"/subscriptions/${var.mgmtSubscriptionId}/resourceGroups/${var.resourceGroups["commonRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.uai_name}":{}}' --cmk-encryption-key-uri $keyVaultKeyUrl --cmk-encryption-state "Enabled" --cmk-identity-type "UserAssigned" --cmk-infrastructure-encryption "Enabled" --cmk-user-assigned-identity-id  "/subscriptions/${var.mgmtSubscriptionId}/resourceGroups/${var.resourceGroups["commonRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.uai_name}" --immutability-state Locked
    EOT
  }
   #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  lifecycle {
    ignore_changes = [triggers]
  }
  depends_on = [module.mgmt_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User]

}

module "conn_storage_backuppolicy_module" {
  source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\storagebackuppolicy\\v1.0"
  for_each                         = var.storagebackupPolicies
  backup_policy_name               = each.value.backup_policy_name
  backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.mgmt_sub_id}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
  vault_default_retention_duration = each.value.vault_default_retention_duration
  backup_instance_name             = each.value.backup_instance_name
  location                         = each.value.location
  storage_account_id               = local.storage_account_id
  backupvaultname                  = each.value.backup_vault_Name
  resource_group_name              = each.value.resource_group_name
  depends_on                       = [module.resource_group, module.mgmt_backupvault_module, module.mgmt_storage_account]
}

locals {
  user_assigned_identity_id = module.mgmt_user_assigned_identity["uai1"].id
}

# CLI command for CMK Encypion on backend storage account (containing tf state files) with HSM Key
resource "null_resource" "tfstorageCMK" {
  provisioner "local-exec" {
    command = <<EOT
      hsmurl=$(az keyvault show --subscription ${var.security_subsId} --hsm-name ${var.HSM.name} --query properties.hsmUri --output tsv)
      az storage account update --name ${var.terraformStorageAccount} --resource-group ${var.terraformStorageRG} --encryption-key-name ${var.hsm_key_name} --encryption-key-source Microsoft.Keyvault --encryption-key-vault $hsmurl --key-vault-user-identity-id ${local.user_assigned_identity_id} --identity-type UserAssigned --user-identity-id ${local.user_assigned_identity_id}
    EOT
  }
   #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  lifecycle {
    ignore_changes = [triggers]
  }
  depends_on = [resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, local.user_assigned_identity_id, data.azurerm_key_vault_managed_hardware_security_module.hsm, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key] #, module.mgmt_network_peering
}

# mgmt Private Endpoint
module "mgmt_private_endpoint" {
  for_each                       = var.mgmtPrivateEndpoint
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\privateendpoint\\v1.0"
  private_endpoint_name          = each.value.private_endpoint_name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  subnet_id                      = module.mgmt_subnet_module[each.value.subnet_id].id
  private_dns_zone_id            = each.value.private_dns_zone_id
  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  depends_on                     = [module.mgmt_subnet_module, module.mgmt_storage_account, module.mgmt_pvt_dns_link] #null_resource.tfstorageCMK
}


module "mgmt_automation_account_module" {
  source                        = "..\\..\\terraform-modules-hub\\terraform-modules\\automationAccount\\v1.0"
  for_each                      = var.automation_accounts
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku                           = each.value.sku
  local_authentication_enabled  = each.value.local_authentication_enabled
  public_network_access_enabled = false
  identity_type                 = "UserAssigned"
  identity_ids                  = [module.mgmt_user_assigned_identity["uai1"].id]
  tags                          = each.value.tags
  depends_on                    = [module.mgmt_user_assigned_identity, module.resource_group]
}


# referring the auto created network watcher
data "azurerm_network_watcher" "mgmt_network_watcher" {
  name                = var.network_watcher_name
  resource_group_name = var.network_watcher_rg
}

#Referring law form security subscription
data "azurerm_log_analytics_workspace" "security_law" {
  provider            = azurerm.securitySub
  name                = var.security_law_name
  resource_group_name = var.security_law_rg
}

# mgmt NSG flow logs storage account id created above
locals {
  storage_account_id = "/subscriptions/${var.mgmtSubscriptionId}/resourceGroups/${var.commonResourceGroupName}/providers/Microsoft.Storage/storageAccounts/${var.nsgFlowStorageAccountName}"
}

# mgmt NSG flow logs - can be tested only after the network watcher is enabled in each subscription
module "mgmt_nsg_flow_logs_module" {
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\nsgflowlogs\\v2.0"
  for_each                     = var.mgmtFlowLogs
  network_watcher_name         = data.azurerm_network_watcher.mgmt_network_watcher.name
  resource_group_name          = data.azurerm_network_watcher.mgmt_network_watcher.resource_group_name
  nsg_flow_log_name            = each.value.nsg_flow_log_name
  location                     = each.value.location
  nsg_id                       = each.value.nsgName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.nsgName}"
  storage_account_id           = local.storage_account_id
   workspace_resource_id        = data.azurerm_log_analytics_workspace.security_law.id
  workspace_id                 = data.azurerm_log_analytics_workspace.security_law.workspace_id
  depends_on                   = [data.azurerm_log_analytics_workspace.security_law,data.azurerm_network_watcher.mgmt_network_watcher, module.mgmt_storage_account, module.mgmt_nsg_module]
}

# # [Optional] mgmt - user access administrator rbac on subscription for mgmt service principal, also this can be used a reference to use RBAC module
# module "mgmt_rbac1" {
#   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
#   scope                = "/subscriptions/${var.mgmtSubscriptionId}"
#   principal_id         = data.azurerm_client_config.current.object_id
#   role_definition_name = "Storage Account Contributor" # optional for mgmt service principal to assign RBACs on resources as necessary
#   depends_on           = [data.azurerm_client_config.current]
# }

#--------------------------------------------------------------------------

module "maintenance_configuration_module" {
  for_each                       = var.maintenance_configurations
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\updatemanager\\maintenance_configuration\\v1.0"
  maintenance_configuration_name = each.value.maintenance_configuration_name
  resource_group_name            = each.value.resource_group_name
  location                       = var.mainLocation
  tags                           = each.value.tags
  scope                          = each.value.scope
  visibility                     = each.value.visibility
  in_guest_user_patch_mode       = each.value.in_guest_user_patch_mode

  maintenance_start_time      = each.value.start_date_time
  maintenance_expiration_time = each.value.expiration_date_time
  maintenance_duration        = each.value.duration
  timezone                    = each.value.time_zone
  recur_every                 = each.value.recur_every

  linux_classifications   = each.value.linux_classifications
  linux_excluded_packages = each.value.linux_excluded_packages
  linux_included_packages = each.value.linux_included_packages
  windows_classifications = each.value.windows_classifications
  kb_numbers_to_exclude   = each.value.kb_numbers_to_exclude
  kb_numbers_to_include   = each.value.kb_numbers_to_include
  reboot                  = each.value.reboot

  depends_on = [module.resource_group]
}

module "dynamic_scope_maintenance_module" {
  for_each                       = var.dynamic_scope_maintenance
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\updatemanager\\dynamicscope_maintenance\\v1.0"
  maintenance_configuration_name = each.value.maintenance_configuration_name
  dynamic_scope_maintenance_name = each.value.dynamic_scope_maintenance_name
  resource_group_name            = each.value.resource_group_name
  resource_group_names           = each.value.resource_group_names
  depends_on                     = [module.maintenance_configuration_module, module.resource_group]
}

module "vm_maintenance_assignment_module" {
  for_each                       = var.vm_maintenance_assignments
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\updatemanager\\vm_maintenance_assignment\\v1.0"
  maintenance_configuration_name = each.value.maintenance_configuration_name
  resource_group_name            = each.value.resource_group_name
  location                       = var.mainLocation
  virtual_machine_id             = each.value.virtual_machine_id
  depends_on                     = [module.maintenance_configuration_module]
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
  depends_on                     = [module.mgmt_storage_account]
}




