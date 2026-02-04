data "azurerm_client_config" "current" {}

#needed
module "resource_group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules\\resourcegroup\\v1.0"
  location            = each.value.location
  resource_group_name = each.value.name
  tags                = each.value.tags
}

module "sharedservices_user_assigned_identity" {
  source              = "..\\..\\terraform-modules\\userassignedidentity\\v1.0"
  name                = var.sharedservicesuan
  location            = var.mainLocation
  resource_group_name = var.resourceGroups["netRG"].name
  depends_on          = [module.resource_group]
}

#storage account
module "storage_account" {
  for_each                        = var.storageAccounts
  source                          = "..\\..\\terraform-modules\\storageaccount\\v1.0"
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  name                            = each.value.name
  user_assigned_identity_id       = module.sharedservices_user_assigned_identity.id
  identity_type                   = "UserAssigned"
  identity_ids                    = [module.sharedservices_user_assigned_identity.id]
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  queue_encryption_key_type       = "Account"
  table_encryption_key_type       = "Account"
  depends_on                      = [module.resource_group, module.sharedservices_user_assigned_identity]
}

# virtual networks
module "sharedservices_vnet_module" {
  for_each                     = var.sharedservicesVirtualNetworks
  source                       = "..\\..\\terraform-modules\\virtualnetwork\\v1.0"
  virtual_network_name         = each.value.VirtualNetworkName
  resource_group_name          = each.value.resourceGroupName
  location                     = var.mainLocation
  address_space                = [each.value.address_space]
  tags                         = { environment = var.environment }
  depends_on                   = [module.resource_group]
}

#needed
# subnets
module "sharedservices_subnet_module" {
  for_each                  = var.sharedservicesSubnets
  source                    = "..\\..\\terraform-modules\\subnet\\v1.0"
  resource_group_name       = each.value.resourceGroupName
  virtual_network_name      = each.value.vnet_name
  subnet_name               = each.value.name
  address_prefixes          = [each.value.addressPrefix]
  # route_table_id            = each.value.routeTableName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/routeTables/${each.value.routeTableName}"
  # network_security_group_id = each.value.networkSecurityGroupId == null || each.value.subscriptionId == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.networkSecurityGroupId}"
  depends_on                = [module.resource_group, module.sharedservices_vnet_module]
  service_endpoints         = ["Microsoft.KeyVault"]
}

#needed
# // # route table
# module "sharedservices_route_table_module" {
#   for_each            = var.sharedservicesRouteTables
#   source              = "..\\..\\terraform-modules-hub\\terraform-modules\\routetable\\v1.0"
#   resource_group_name = each.value.resourceGroupName
#   route_table_name    = each.value.routeTableName
#   location            = var.mainLocation
#   tags                = { environment = var.environment }
#   route_table = {
#     bgp_route_propagation_enabled = each.value.enableBgpRoutePropagation
#     routes                        = each.value.routes
#   }
#   depends_on = [module.resource_group]
# }

#needed
# # sharedservicesectivity NSG
# module "sharedservices_nsg_module" {
#   source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\networksecuritygroup\\v1.0"
#   main_location           = var.mainLocation
#   environment             = var.environment
#   network_security_groups = var.sharedservicesNetworkSecurityGroups
#   depends_on              = [module.resource_group]
# }


# module "sharedservices_private_endpoint" {
#   for_each                       = var.sharedservicesPrivateEndpoint
#   source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\privateendpoint\\v1.0"
#   private_endpoint_name          = each.value.private_endpoint_name
#   resource_group_name            = var.resourceGroups["netRG"].name
#   location                       = each.value.location
#   subnet_id                      = module.sharedservices_subnet_module["vnet-sao-sharedservices-aen-001_ksp-pcw-sharedservices-platform-ci-vnet-01-snet-01"].id
#   private_dns_zone_id            = each.value.private_dns_zone_id
#   private_connection_resource_id = each.value.private_connection_resource_id
#   subresource_names              = each.value.subresource_names
#   depends_on                     = [module.sharedservices_subnet_module, module.sharedservices_vnet_module]
# }


# # referring private dns zone from supporting-infrastructure RG
# data "azurerm_private_dns_zone" "dnszone" {
#   provider            = azurerm.connSub
#   name                = var.private_dns_zone_name
#   resource_group_name = var.dnszone_resource_group_name
# }

# # mgmt Private DNS Link
# module "ss_pvt_dns_link" {
#   providers = {
#     azurerm = azurerm.connSub
#   }
#   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\privatednszonevirtualnetworklink\\v1.0"
#   for_each             = var.sharedserviceDNSLink
#   name                 = each.value.name
#   resource_group_name  = each.value.resource_group_name
#   private_dns_zone     = each.value.private_dns_zone_name
#   virtual_network_id   = module.sharedservices_vnet_module["vnet-sao-sharedservices-aen-001"].id
#   registration_enabled = each.value.registration_enabled
#   depends_on           = [module.sharedservices_vnet_module, data.azurerm_private_dns_zone.dnszone]
# }

# #ddos plan
# module "ddos_plan_module" {
#   source        = "..\\..\\terraform-modules-hub\\terraform-modules\\ddos\\v1.0"
#   main_location = var.mainLocation
#   environment   = var.environment
#   ddos_plans    = var.SharedServicesDDos
#   depends_on    = [module.resource_group]
# }


# # allow all aproach
# # Jumpbox VM module
# module "jumpbox_vm_module" {
#   source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\windowsvm\\v1.0-acc"
#   location                = var.mainLocation
#   administrator_user_name = var.adminUser
#   windows_vms             = var.sharedservicesJumpBoxVms
#   resource_group_name     = var.resource_group_name
#   disk_encryption_set_id  = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/diskEncryptionSets/${var.disk_encryption_set_name}"
#   identity_type           = "UserAssigned"
#   identity_ids            = module.sharedservices_user_assigned_identity.id
#   depends_on              = [module.sharedservices_vnet_module, module.sharedservices_subnet_module, module.resource_group, null_resource.HSM_Keys] //,module.sharedservices_disk_encryption_set] //local.disk_encryption_set_id]//
# }


# #needed
# # allow all aproach

# module "windows_guest_attestation" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesJumpBoxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "GuestAttestation"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.jumpbox_vm_module]
# }



# # Antimalware extension for VM
# module "antimalware_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesJumpBoxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "IaaSAntimalware"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Security"
#   type                       = "IaaSAntimalware"
#   type_handler_version       = "1.3"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = false
#   settings                   = <<SETTINGS
#   {
#       "AntimalwareEnabled": true,
#       "RealtimeProtectionEnabled": "true",
#       "ScheduledScanSettings": {
#         "isEnabled": "true",
#         "day": "7",
#         "time": "120",
#         "scanType": "Quick"
#       }
#   }
#   SETTINGS
#   protected_settings         = lookup(each.value, "protected_settings", null)
#   depends_on                 = [module.jumpbox_vm_module, module.resource_group]
#   tags                       = { "environment" : var.environment }
# }

# #disable local auth
# module "disableLocalauth_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesJumpBoxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "DisableLocalAuth"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.10"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = false
#   settings                   = <<SETTINGS
#       {
#       "commandToExecute": "powershell.exe -Command \"Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' -Name 'LocalAccountTokenFilterPolicy' -Value 0\""
#     }
#   SETTINGS
#   protected_settings         = lookup(each.value, "protected_settings", null)
#   depends_on                 = [module.jumpbox_vm_module, module.resource_group]
#   tags                       = { "environment" : var.environment }
# }

# #dependency agent
# module "daagent_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesJumpBoxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "DependencyAgentWindows"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
#   type                       = "DependencyAgentWindows"
#   type_handler_version       = "9.9"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = false
#   protected_settings         = lookup(each.value, "protected_settings", null)
#   depends_on                 = [module.jumpbox_vm_module, module.resource_group]
#   tags                       = { "environment" : var.environment }
# }



# # allow all aproach
# # DiagnosticSetting extension for VM
# module "diagnostic_setting_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesJumpBoxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "Microsoft.Insights.VMDiagnosticsSettings"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Diagnostics"
#   type                       = "IaaSDiagnostics"
#   type_handler_version       = "1.5"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = false
#   settings                   = <<SETTINGS
#     {
#         "StorageAccount": "${data.azurerm_storage_account.storage_account.name}",
#         "WadCfg": {
#           "DiagnosticMonitorConfiguration": {
#             "Metrics": {
#               "resourceId": "/${each.value.subscriptionId}/resourceGroups/${each.value.resourceGroupName}/providers/Microsoft.Compute/virtualMachines/${each.value.vmName}"
#             }
#           }
#         }
#     }
#   SETTINGS
#   protected_settings         = <<SETTINGS
#   {
#     "storageAccountName": "${data.azurerm_storage_account.storage_account.name}",
#     "storageAccountKey": "${data.azurerm_storage_account.storage_account.primary_access_key}",
#     "storageAccountEndPoint": "https://${data.azurerm_storage_account.storage_account.primary_blob_endpoint}"
#   }
#   SETTINGS
#   depends_on                 = [module.jumpbox_vm_module, module.resource_group]
#   tags                       = { "environment" : var.environment }
# }

# #Linux VM

# module "linux_vm_module" {
#   source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\linuxvm\\v1.0-acc"
#   location                = var.mainLocation
#   administrator_user_name = var.adminUser
#   linux_vms               = var.sharedservicesLinuxVms
#   resource_group_name     = var.resource_group_name
#   disk_encryption_set_id  = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/diskEncryptionSets/${var.disk_encryption_set_name}"
#   identity_type           = "UserAssigned"
#   identity_ids            = module.sharedservices_user_assigned_identity.id
#   depends_on              = [null_resource.HSM_Keys, module.sharedservices_vnet_module, module.sharedservices_subnet_module, module.resource_group] //,module.sharedservices_disk_encryption_set]
# }


# module "linux_guest_attestation" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesLinuxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "GuestAttestation"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Security.LinuxAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.linux_vm_module]
# }

# module "linux_daagent_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesLinuxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "DependencyAgentLinux"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorLinuxAgent"
#   type_handler_version       = "1.33"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = false
#   protected_settings         = lookup(each.value, "protected_settings", null)
#   depends_on                 = [module.linux_vm_module, module.resource_group]
#   tags                       = { "environment" : var.environment }

# }

# #SQL PAAS

# module "sharesservices_sql_paas" {
#   for_each            = var.sharedservicesSQLDB
#   source              = "..\\..\\terraform-modules-hub\\terraform-modules\\sqlpaas\\v1.0"
#   resource_group_name = each.value.resource_group_name
#   location            = each.value.location
#   server_name         = each.value.serverName
#   administrator_login = each.value.administratorLogin
#   database_name       = each.value.databaseName
#   max_size_gb         = each.value.maxSizeGB
#   zone_redundant      = each.value.zoneRedundant
#   license_type        = each.value.licenseType
#   email_addresses     = each.value.emailAddresses
#   depends_on          = [module.resource_group]
# }

# module "shared_storage_backuppolicy_module" {
#   source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\storagebackuppolicy\\v1.0"
#   for_each                         = var.storagebackupPolicies
#   backup_policy_name               = each.value.backup_policy_name
#   backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.shared_sub_id}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
#   vault_default_retention_duration = each.value.vault_default_retention_duration
#   backup_instance_name             = each.value.backup_instance_name
#   location                         = each.value.location
#   storage_account_id               = local.storage_account_id
#   backupvaultname                  = each.value.backup_vault_Name
#   resource_group_name              = each.value.resource_group_name
#   depends_on                       = [module.resource_group, module.shared_backupvault_module, module.storage_account]
# }

# module "shared_disk_backup_polcy_module" {
#   source                           = "..\\..\\terraform-modules-hub\\terraform-modules\\diskbackuppolicy\\v1.0"
#   for_each                         = var.diskBackupPolicies
#   location                         = each.value.location
#   backup_policy_name               = each.value.backup_policy_name
#   backup_vault_id                  = each.value.backup_vault_Name == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["backupRG"].name}/providers/Microsoft.DataProtection/backupVaults/${each.value.backup_vault_Name}"
#   backupvaultname                  = each.value.backup_vault_Name
#   backupvault_resource_group_name  = each.value.backupvault_resource_group_name
#   managed_disk_name                = "${each.value.vmName}-${each.value.osType}"
#   managed_disk_resource_group_name = each.value.managed_disk_resource_group_name
#   snapshot_resource_group_name     = each.value.snapshot_resource_group_name
#   backup_instance_name             = each.value.backup_instance_name
#   depends_on                       = [module.shared_backupvault_module, module.resource_group, module.jumpbox_vm_module]

# }


# #needed
# ## rbac
# module "sharedservices_rbac_module" {
#   source               = "..\\..\\terraform-modules-hub\\terraform-modules\\rbac\\v1.0"
#   for_each             = var.resourceGroups
#   scope                = module.resource_group[each.key].id
#   principal_id         = data.azurerm_client_config.current.object_id
#   role_definition_name = "Storage Account Contributor"
#   depends_on           = [module.resource_group]
# }



# #mgmt RG
# # log analytics
# module "log_analytics_workspace" {
#   source     = "..\\..\\terraform-modules-hub\\terraform-modules\\loganalytics\\v1.0"
#   workspaces = var.workspaces
#   location   = var.mainLocation
#   tags       = var.tags
# }

# module "data_collection_endpoint" {
#   for_each                      = var.shareddatacollectionendpoint
#   source                        = "..\\..\\terraform-modules-hub\\terraform-modules\\datacollectionendpoint\\v1.0"
#   name                          = each.value.datacollectionendpoint
#   resource_group_name           = each.value.resource_group_name
#   location                      = each.value.location
#   kind                          = each.value.kind
#   public_network_access_enabled = false
#   depends_on                    = [module.resource_group]
# }

# # associate resource to a Data Collection Endpoint
# resource "azurerm_monitor_data_collection_rule_association" "Association" {
#   for_each                    = var.dce_resource_association
#   target_resource_id          = each.value.target_resource_id
#   data_collection_endpoint_id = module.data_collection_endpoint[each.value.datacollectionendpoint].id
#   depends_on                  = [module.data_collection_endpoint]
# }

# module "data_collection_rule" {
#   for_each = var.dcr_configs
#   source   = "..\\..\\terraform-modules-hub\\terraform-modules\\datacollectionrule\\v1.0"

#   dcr_name                 = each.value.dcr_name
#   dcr_rg_name              = each.value.dcr_rg_name
#   dcr_rg_location          = each.value.dcr_rg_location
#   dce_name                 = each.value.dce_name
#   dce_rg_name              = each.value.dce_rg_name
#   law_name                 = var.workspaces["workspace1"].name
#   law_rg_name              = var.resourceGroups["laRG"].name
#   destination_logworkspace = each.value.destination_logworkspace
#   data_flow_streams        = each.value.data_flow_streams

#   # Windows-specific data sources
#   os_type                          = each.value.os_type
#   datasource_perfcounter           = each.value.datasource_perfcounter
#   datasource_perfCounterSpecifiers = each.value.datasource_perfCounterSpecifiers
#   win_perfcounter_name             = each.value.win_perfcounter_name
#   win_event_log_stream             = each.value.win_event_log_stream
#   win_path_Query                   = each.value.win_path_Query
#   win_log_name                     = each.value.win_log_name

#   # Linux-specific data sources
#   linux_log_name         = each.value.linux_log_name
#   linux_event_log_stream = each.value.linux_event_log_stream


#   tags       = each.value.tags
#   depends_on = [module.data_collection_endpoint, module.log_analytics_workspace]
# }

# data "azurerm_network_watcher" "shared_network_watcher_module" {
#   name                = var.network_watcher_name
#   resource_group_name = var.network_watcher_rg
# }

# #Referring law form security subscription
# data "azurerm_log_analytics_workspace" "security_law" {
#   provider            = azurerm.securitySub
#   name                = var.security_law_name
#   resource_group_name = var.security_law_rg
# }

# # # NSG flow logs - can be tested only after the network watcher is enabled in each subscription
# module "shared_nsg_flow_logs_module" {
#   for_each                     = var.sharedFlowLog
#   source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\nsgflowlogs\\v2.0"
#   network_watcher_name         = data.azurerm_network_watcher.shared_network_watcher_module.name
#   resource_group_name          = data.azurerm_network_watcher.shared_network_watcher_module.resource_group_name
#   nsg_flow_log_name            = each.value.nsg_flow_log_name
#   location                     = each.value.location
#   nsg_id                       = each.value.nsgId
#   storage_account_id           = local.storage_account_id
#    workspace_resource_id        = data.azurerm_log_analytics_workspace.security_law.id
#   workspace_id                 = data.azurerm_log_analytics_workspace.security_law.workspace_id
#   depends_on                   = [data.azurerm_network_watcher.shared_network_watcher_module, module.resource_group, data.azurerm_log_analytics_workspace.security_law, module.storage_account]
# }

# # #diagnostics logs
# module "diagnostic_setting" {
#   for_each                       = var.diagnostic_logs
#   source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\diagnosticlogs"
#   name                           = each.value.name
#   target_resource_id             = each.value.target_resource_id
#   storage_account_id             = each.value.storage_account_id
#   log_analytics_workspace_id     = each.value.log_analytics_workspace_id
#   eventhub_name                  = each.value.eventhub_name
#   eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
#   logs_categories                = each.value.logs_categories
#   metrics                        = each.value.metrics
#   depends_on                     = [module.storage_account]
# }


# ##RSV module
# module "shared_recovery_service_vault" {
#   for_each                     = var.sharedRecoveryServiceVault
#   source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\recoveryservicevault"
#   recovery_services_vault_name = each.value.recovery_services_vault_name
#   location                     = var.mainLocation
#   resource_group_name          = each.value.resource_group_name
#   sku                          = each.value.sku
#   identity_type                = each.value.identity_type
#   identity_ids                 = [module.sharedservices_user_assigned_identity.id]
#   depends_on                   = [module.resource_group, module.sharedservices_user_assigned_identity]
# }

# locals {
#   rsv_name          = var.sharedRecoveryServiceVault["rsv1"].recovery_services_vault_name
# }


# # #VM Backup policy
# module "vm_backup_policy_module" {
#   source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\vmbackuppolicy\\v1.0"
#   for_each                = var.vm_backup_policies
#   backup_policy_name      = each.value.backup_policy_name
#   recovery_vault_name     = each.value.recovery_vault_name
#   rsv_resource_group_name = each.value.rsv_resource_group_name
#   backup_frequency        = each.value.backup_frequency
#   backup_time             = each.value.backup_time
#   retention_daily_count   = each.value.retention_daily_count
#   vm_name                 = each.value.vm_name
#   vm_resource_group_name  = each.value.vm_resource_group_name
#   depends_on              = [module.shared_recovery_service_vault,module.jumpbox_vm_module]
# }


# #Diagnostic Settings

# module "diagnostic_setting" {
#   for_each                       = var.diagnostic_logs
#   source                         = "..\\..\\terraform-modules-hub\\terraform-modules\\diagnosticlogs"
#   name                           = each.value.name
#   target_resource_id             = each.value.target_resource_id
#   storage_account_id             = each.value.storage_account_id
#   log_analytics_workspace_id     = each.value.log_analytics_workspace_id
#   eventhub_name                  = each.value.eventhub_name
#   eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
#   logs_categories                = each.value.logs_categories
#   metrics                        = each.value.metrics
#   depends_on                     = [module.storage_account, module.log_analytics_workspace]
# }

####----------------------------------------------------------------------------------------------------------------
