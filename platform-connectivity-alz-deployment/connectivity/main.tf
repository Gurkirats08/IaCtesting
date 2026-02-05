data "azurerm_client_config" "current" {}

#Multiple Resource Group
module "terraform_azurerm_resource_group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcegroup\\v1.0"
  location            = each.value.location
  resource_group_name = each.value.name
  tags                = each.value.tags
}

#---------------------------------------------------------------------------------------------------
#Network resources in Network RG 

module "conn_nsg_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\networksecuritygroup\\v1.0"
  main_location           = var.mainLocation
  environment             = var.environment
  network_security_groups = var.connNetworkSecurityGroups
  depends_on = [
    module.terraform_azurerm_resource_group
  ]
}

module "conn_vnet_module" {
  for_each             = var.connVirtualNetworks
  source               = "..\\..\\terraform-modules-hub\\terraform-modules\\virtualnetwork\\v1.0"
  virtual_network_name = each.value.VirtualNetworkName
  resource_group_name  = each.value.resourceGroupName
  location             = var.mainLocation
  address_space        = [each.value.address_space]
  ddos_protection_plan_ddos_id = module.ddos_plan_module[each.value.DDosProtectionPlan].ddos_protection_plan_ids
  tags       = { environment = var.environment }
  depends_on = [module.terraform_azurerm_resource_group]
}

# subnets
module "conn_subnet_module" {
  for_each                  = var.connSubnets
  source                    = "..\\..\\terraform-modules-hub\\terraform-modules\\subnet\\v1.0"
  resource_group_name       = each.value.resourceGroupName
  virtual_network_name      = each.value.vnet_name
  subnet_name               = each.value.name
  address_prefixes          = [each.value.addressPrefix]
  route_table_id            = each.value.routeTableName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/routeTables/${each.value.routeTableName}"
  network_security_group_id = each.value.nsgName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.nsgName}"
  depends_on                = [module.terraform_azurerm_resource_group, module.conn_vnet_module, module.conn_nsg_module, module.conn_route_table_module]
  service_endpoints         = ["Microsoft.KeyVault"]
}

module "conn_route_table_module" {
  for_each            = var.connRouteTables
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\routetable\\v1.0"
  resource_group_name = each.value.resourceGroupName
  route_table_name    = each.value.routeTableName
  location            = var.mainLocation
  tags                = { environment = var.environment }
  route_table = {
    bgp_route_propagation_enabled = each.value.enableBgpRoutePropagation
    routes                        = each.value.routes
  }
  depends_on = [module.terraform_azurerm_resource_group]
}

module "ddos_plan_module" {
  source        = "..\\..\\terraform-modules-hub\\terraform-modules\\ddos\\v1.0"
  main_location = var.mainLocation
  environment   = var.environment
  ddos_plans    = var.connDDos
  depends_on    = [module.terraform_azurerm_resource_group]
}

#Firewall Resource Group

module "firewall_ip_module" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\publicip\\v1.0"
  public_IPs          = var.connFirewalls
  main_location       = var.mainLocation
  environment         = var.environment
  resource_group_name = var.resourceGroups["netRG"].name
  depends_on          = [module.terraform_azurerm_resource_group]
}
module "firewall_policy_module" {
  source          = "..\\..\\terraform-modules-hub\\terraform-modules\\firewallPolicy\\v1.0"
  main_location   = var.mainLocation
  environment     = var.environment
  firewall_policy = var.connFirewalls
  depends_on      = [module.terraform_azurerm_resource_group]
}
module "firewall_module" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\azurefirewall\\v1.0"
  resource_group_name = var.resourceGroups["netRG"].name
  location            = var.mainLocation
  environment         = var.environment
  firewalls           = var.connFirewalls
  firewall_ip_ids     = module.firewall_ip_module.public_ip_ids
  firewall_policy_ids = module.firewall_policy_module.firewall_policy_id
  depends_on          = [module.firewall_ip_module, module.firewall_policy_module, module.conn_vnet_module, module.terraform_azurerm_resource_group, module.conn_subnet_module]
}




#-----------------------------------------------------------------------------------------------
# Bastion Resources

#  bastion IP module
module "bastion_ip_module" {
  for_each            = var.connVirtualNetworks
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\publicip\\v1.0"
  resource_group_name = var.resourceGroups["basRG"].name
  main_location       = var.mainLocation
  environment         = var.environment
  public_IPs = {
    "bastion" = {
      bastionIPName            = each.value.bastionIPName
      publicIPAllocationMethod = "Static"
      skuName                  = each.value.sku_name
      resourceGroupName        = var.resourceGroups["basRG"].name
      tags = {
        environment = var.environment
      }
    }
  }
  depends_on = [module.terraform_azurerm_resource_group]
}

# bastion host module
module "bastion_host_module" {
  source            = "..\\..\\terraform-modules-hub\\terraform-modules\\bastionhost\\v1.0"
  resourceGroupName = var.resourceGroups["basRG"].name
  main_location     = var.mainLocation
  environment       = var.environment
  bastion_hosts     = var.connVirtualNetworks
  subnetRG          = var.subnetRG
  depends_on        = [module.bastion_ip_module, module.conn_vnet_module, module.terraform_azurerm_resource_group, module.conn_subnet_module]
}

#---------------------------------------------------------------------------------------------------
#Management Resources RG


#User Assigned Identity
module "conn_user_assigned_identity" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
  name                = var.connIdentity
  location            = var.mainLocation
  resource_group_name = var.resourceGroups["mgmtRG"].name
  depends_on          = [module.terraform_azurerm_resource_group]
}


# Hardware Security Module (HSM)
data "azurerm_key_vault_managed_hardware_security_module" "hsm" {
  provider            = azurerm.securitySub
  name                = var.connHSM.name
  resource_group_name = var.connHSM.resource_group_name
}

resource "azurerm_key_vault_managed_hardware_security_module_key" "hsm-key" {
  provider        = azurerm.securitySub
  managed_hsm_id  = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name            = var.hsmKeyName
  key_type        = "RSA-HSM"
  key_size        = 2048
  key_opts        = ["sign", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify"]
  expiration_date = "2026-09-19T23:59:59Z"
  not_before_date = "2024-09-20T00:00:00Z"
  depends_on      = [data.azurerm_key_vault_managed_hardware_security_module.hsm]
}


# # # Rbac for disk on HSM
resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "HSM_Crypto_Service_Encryption_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys/${var.hsmKeyName}"
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/33413926-3206-4cdd-b39a-83574fe37a17"
  principal_id       = module.conn_user_assigned_identity.principal_id
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }
  depends_on         = [module.conn_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
}

resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "Managed_HSM_Crypto_User" {
  provider           = azurerm.securitySub
  managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
  name               = uuid()
  scope              = "/keys/${var.hsmKeyName}"
  role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b"
  principal_id       = module.conn_user_assigned_identity.principal_id
  #Uncomment lifecycle block after development to avoid to running everytime
  # lifecycle {
  #   ignore_changes = [
  #     name
  #   ]
  # }

  depends_on         = [module.conn_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
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

# network Watcher - can be tested only after the network watcher is enabled in each subscription
data "azurerm_network_watcher" "conn_network_watcher_module" {
  name                = var.network_watcher_name
  resource_group_name = var.network_watcher_rg
}

locals {
  storage_account_id = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.nsgFlowstorageAccountResourceGroupName}/providers/Microsoft.Storage/storageAccounts/${var.nsgFlowstorageAccountName}"
}


#Referring law form security subscription
data "azurerm_log_analytics_workspace" "security_law" {
  provider            = azurerm.securitySub
  name                = var.security_law_name
  resource_group_name = var.security_law_rg
}


# # # NSG flow logs - can be tested only after the network watcher is enabled in each subscription
module "conn_nsg_flow_logs_module" {
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\nsgflowlogs\\v2.0"
  network_watcher_name         = data.azurerm_network_watcher.conn_network_watcher_module.name
  resource_group_name          = data.azurerm_network_watcher.conn_network_watcher_module.resource_group_name
  nsg_flow_log_name            = var.connFlowLog.nsg_flow_log_name
  location                     = var.connFlowLog.location
  nsg_id                       = var.connFlowLog.nsgId
  storage_account_id           = local.storage_account_id
   workspace_resource_id        = data.azurerm_log_analytics_workspace.security_law.id
  workspace_id                 = data.azurerm_log_analytics_workspace.security_law.workspace_id
  depends_on                   = [data.azurerm_network_watcher.conn_network_watcher_module, module.terraform_azurerm_resource_group, module.terraform-azurerm-storage-account, data.azurerm_log_analytics_workspace.security_law]
}



#----------------------------------------------------------------------------------------------------
#Migration Resources RG

# Private Endpoint

module "conn_private_endpoint" {
  for_each                       = var.connPrivateEndpoint
  source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\privateendpoint\\v1.0"
  private_endpoint_name          = each.value.private_endpoint_name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  subnet_id                      = module.conn_subnet_module[each.value.subnet_id].id
  private_dns_zone_id            = module.dns_zone_module[each.value.private_dns_zone_id].id
  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  depends_on                     = [module.conn_subnet_module, module.dns_zone_module]
}

#----------------------------------------------------------------------------------------------------
#PaaS Resources RG


# # Storage Account

module "terraform-azurerm-storage-account" {
  source                        = "..\\..\\terraform-modules-hub\\terraform-modules\\storageaccount\\v1.0"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  resource_group_name           = var.nsgFlowstorageAccountResourceGroupName
  location                      = var.mainLocation
  name                          = var.nsgFlowstorageAccountName
  key_vault_key_id              = resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key.id
  user_assigned_identity_id     = module.conn_user_assigned_identity.id
  identity_type                 = "UserAssigned"
  identity_ids                  = [module.conn_user_assigned_identity.id]
  public_network_access_enabled = false
  shared_access_key_enabled     = false
  queue_encryption_key_type     = "Account"
  table_encryption_key_type     = "Account"
  depends_on                    = [module.conn_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User]
}

#----------------------------------------------------------------------------------------------------
#DNS Zone RG
# Private DNS Zone

module "dns_zone_module" {
  for_each              = var.connPrivateDNSZones
  source                = "..\\..\\terraform-modules-hub\\terraform-modules\\privatednszone\\v1.0"
  private_dns_zone_name = each.value.name
  resource_group_name   = each.value.resourceGroupName
  soa_email             = lookup(each.value, "soaEmail", null)
  depends_on            = [module.terraform_azurerm_resource_group]
}

#-------------------------------------------------------------------------------

# CMK encryption on backend storage account (containing tf state files) with HSM Key
locals {
  user_assigned_identity_id = module.conn_user_assigned_identity.id
}

# CLI command for CMK Encypion on backend storage account (containing tf state files) with HSM Key
resource "null_resource" "tfstorageCMK" {
  provisioner "local-exec" {
    command = <<EOT
      hsmurl=$(az keyvault show --subscription ${var.security_subsId} --hsm-name ${var.connHSM.name} --query properties.hsmUri --output tsv)
      az storage account update --name ${var.terraformStorageAccount} --resource-group ${var.terraformStorageRG} --encryption-key-name ${var.hsmKeyName} --encryption-key-source Microsoft.Keyvault --encryption-key-vault $hsmurl --key-vault-user-identity-id ${local.user_assigned_identity_id} --identity-type UserAssigned --user-identity-id ${local.user_assigned_identity_id}
    EOT
  }
 #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [
  #     triggers
  #   ]
  # }
  depends_on = [resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, local.user_assigned_identity_id, data.azurerm_key_vault_managed_hardware_security_module.hsm, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
}

#--------------------------------------------------------------------------------
#Backup Resources RG
 


resource "null_resource" "backup_vault" {
  provisioner "local-exec" {
    command = <<EOT

    az config set extension.dynamic_install_allow_preview=true

    keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.connHSM.name} --name ${var.hsmKeyName}  --query [key.kid] -o tsv)

    az dataprotection backup-vault create --vault-name ${var.backupVaultName} --resource-group ${var.resourceGroups["backupRG"].name} --location ${var.mainLocation} --storage-setting "[{type:'LocallyRedundant',datastore-type:'VaultStore'}]" --type "SystemAssigned,UserAssigned" --user-assigned-identities '{"/subscriptions/${var.connSubscriptionId}/resourceGroups/${var.resourceGroups["mgmtRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.connIdentity}":{}}' --cmk-encryption-key-uri $keyVaultKeyUrl --cmk-encryption-state "Enabled" --cmk-identity-type "UserAssigned" --cmk-infrastructure-encryption "Enabled" --cmk-user-assigned-identity-id  "/subscriptions/${var.connSubscriptionId}/resourceGroups/${var.resourceGroups["mgmtRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.connIdentity}" --immutability-state Locked
    EOT
  }

  #Uncomment lifecycle after first run when deployment is completed for resource, to avoid triggering it everytime
  # lifecycle {
  #   ignore_changes = [
  #     triggers
  #   ]
  # }
  depends_on = [module.conn_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key,resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User]

}

module "conn_storage_backuppolicy_module" {
  source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\storagebackuppolicy\\v1.0"
  for_each                         = var.storagebackupPolicies
  backup_policy_name               = each.value.backup_policy_name
  backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.conn_sub_id}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
  vault_default_retention_duration = each.value.vault_default_retention_duration
  backup_instance_name             = each.value.backup_instance_name
  location                         = each.value.location
  storage_account_id               = local.storage_account_id
  backupvaultname                  = each.value.backup_vault_Name
  resource_group_name              = each.value.resource_group_name
  depends_on                       = [module.terraform_azurerm_resource_group, module.conn_backupvault_module,module.terraform-azurerm-storage-account]
}


#--------------------------------------------------------------------------------

#Resource Locks
module "conn_resource_lock" {
  for_each            = var.connResourceLocks
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcelock\\v1.0"
  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  lock_level          = each.value.lock_level
  notes               = each.value.notes
  resource_name       = each.value.resource_name
  resource_type       = each.value.resource_type
  subscription_id     = data.azurerm_client_config.current.subscription_id
  depends_on          = [module.terraform_azurerm_resource_group]

}

#-----------------------------------------------------------------------------------------

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
  depends_on                     = [module.terraform-azurerm-storage-account]
}



# (Optional) - Uncomment if Key vault Required!
# # Key Vault

# # module "conn_keyvault_module" {
# #   for_each                 = var.connKeyVaults
# #   source                   = "..\\..\\terraform-modules-hub\\terraform-modules\\keyvault\\v1.0"
# #   key_vault_location       = var.mainLocation
# #   resource_group_name      = var.resourceGroups["migRG"].name
# #   sku_name                 = each.value.sku
# #   key_vault_name           = each.value.name
# #   tenant_id                = data.azurerm_client_config.current.tenant_id
# #   purge_protection_enabled = true
# #   # public_network_access_enabled = false
# #   log_analytics_workspace_id = module.conn_law.law_id_map[var.connWorkspace["law1"].name]

# #   access_policy = [
# #     {
# #       tenant_id = data.azurerm_client_config.current.tenant_id
# #       object_id = module.conn_user_assigned_identity.client_id
# #       key_perms = ["get", "list", "create", "delete", "purge", "recover", "backup", "restore", "wrap", "unwrap"]
# #     }
# #   ]
# #   network_acls = {
# #     bypass         = "AzureServices"
# #     default_action = "Deny"
# #   }
# #   depends_on = [data.azurerm_resource_group.terraform_azurerm_resource_group, module.conn_law]
# # }


# # RBACS

# # module "rbac" {
# #   for_each             = var.connRbacs
# #   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
# #   scope                = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["connRG"].name}/providers/${each.value.provider}/${each.value.resource_type}/${each.value.resource_name}"
# #   principal_id         = data.azurerm_client_config.current.object_id
# #   role_definition_name = each.value.role_definition_name
# #   depends_on           = [module.conn_keyvault_module]
# # }

# # module "rbac1" {
# #   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
# #   scope                = module.conn_keyvault_module["kv-phi-conn-eus-001"].key_vault_id
# #   principal_id         = module.conn_user_assigned_identity.principal_id
# #   role_definition_name = "Key Vault Secrets User"
# #   depends_on           = [module.conn_keyvault_module, module.conn_user_assigned_identity]
# # }
# # module "rbac2" {
# #   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
# #   scope                = module.conn_keyvault_module["kv-phi-conn-eus-001"].key_vault_id
# #   principal_id         = module.conn_user_assigned_identity.principal_id
# #   role_definition_name = "Key Vault Crypto User"
# #   depends_on           = [module.conn_keyvault_module, module.conn_user_assigned_identity]
# # }

# # # Key Vault Key

# # module "conn_kvKey" {
# #   for_each           = var.connKeyVaultKeys
# #   source             = "..\\..\\terraform-modules-hub\\terraform-modules\\keyvaultkey\\v1.0"
# #   key_vault_key_name = each.value.key_name
# #   key_vault_id       = module.conn_keyvault_module["kv-phi-conn-eus-001"].key_vault_id
# #   key_type           = each.value.key_type
# #   key_opts           = each.value.key_opts
# #   key_size           = 4096
# #   expiration_date    = each.value.expiration_date
# #   depends_on         = [module.conn_keyvault_module, module.rbac, module.rbac1, module.rbac2]
# # }


#---------------------------------------------------------------------------------------



