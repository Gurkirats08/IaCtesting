# Global Variables
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "mainLocation" {
  type        = string
  description = "Resource Location"
}

// variable "storageAccountName"{
//   type = string
//   description = "storage for diagnostics"
// }

// variable "storageAccountResourceGroupName"{
//   type = string
//   description = "storage for diagnostics"
// }

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "backupVaultName" {
#   type        = string
#   description = "Backup Vault Name"

# }

#uan
variable "sharedservicesuan" {
  type        = string
  description = "user assigned identity"
}

variable "subscriptionId" {
  type        = string
  description = "shared services sub ID"
}


# Resource Group
variable "resourceGroups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}


# storage account
variable "storageAccounts" {
  description = "Storage Accounts"
  type = map(object({
    name                      = string
    account_tier              = string
    account_replication_type  = string
    resource_group_name       = string
    location                  = string
    shared_access_key_enabled = optional(bool)

  }))
  default = {}
}
variable "network_watcher_name" {
  description = "Network Watcher Name"
  type        = string
}

variable "network_watcher_rg" {
  description = "Network Watcher Resource Group"
  type        = string
}

# Virtual Network
variable "sharedservicesVirtualNetworks" {
  description = "Virtual networks"
  type = map(object({
    resourceGroupName  = string
    subscriptionId     = string
    VirtualNetworkName = string
    address_space      = string
    bastionIPName      = string
    sku_name           = string
    bastionName        = string
    DDosProtectionPlan = string
  }))
  default = {}
}

#subnets
variable "sharedservicesSubnets" {
  description = "The subnets with their properties."
  type = map(object({
    resourceGroupName      = string
    vnet_key               = string
    name                   = string
    addressPrefix          = string
    vnet_name              = string
    networkSecurityGroupId = string
    routeTableName         = optional(string)
    subscriptionId         = optional(string)
  }))
  default = {}
}


# variable "private_dns_zone_name" {
#   type        = string
#   description = "Private DNS Zone"
# }

# variable "dnszone_resource_group_name" {
#   type        = string
#   description = "RG for dns zone"
# }

# variable "security_law_rg" {
#   type        = string
#   description = "Log Analytics Workspace Resource Group"

# }

# variable "security_law_name" {
#   type        = string
#   description = "Log Analytics Workspace Name"

# }

# variable "sharedserviceDNSLink" {
#   type = map(object({
#     name                  = string
#     resource_group_name   = string
#     private_dns_zone_name = string
#     registration_enabled  = bool
#   }))
# }

# #ddos
# variable "SharedServicesDDos" {
#   description = "The DDoS plans with their properties."
#   type = map(object({
#     name              = string
#     resourceGroupName = string
#     tags              = optional(map(string))
#   }))
#   default = {}
# }

# #private endpoints
# variable "sharedservicesPrivateEndpoint" {
#   type = map(object({
#     private_endpoint_name          = string
#     resource_group_name            = string
#     location                       = string
#     subnet_id                      = string
#     private_dns_zone_id            = string
#     private_connection_resource_id = string
#     subresource_names              = list(string)
#   }))
# }

# #route table
# variable "sharedservicesRouteTables" {
#   type = map(object({
#     resourceGroupName         = string
#     routeTableName            = string
#     enableBgpRoutePropagation = bool
#     routes = list(object({
#       name             = string
#       addressPrefix    = string
#       nextHopType      = string
#       NextHopIpAddress = optional(string)
#     }))
#   }))
#   description = "The route tables with their properties."
#   default     = {}
# }

# #nsg
# variable "sharedservicesNetworkSecurityGroups" {
#   type = map(object({
#     name              = string
#     tags              = optional(map(string))
#     resourceGroupName = string
#     securityRules = list(object({
#       name        = string
#       description = optional(string)
#       properties = object({
#         protocol                                 = string
#         direction                                = string
#         access                                   = string
#         priority                                 = number
#         sourceAddressPrefix                      = optional(string)
#         sourceAddressPrefixes                    = optional(list(string))
#         destinationAddressPrefix                 = optional(string)
#         destinationAddressPrefixes               = optional(list(string))
#         sourcePortRange                          = optional(string)
#         sourcePortRanges                         = optional(list(string))
#         destinationPortRange                     = optional(string)
#         destinationPortRanges                    = optional(list(string))
#         sourceApplicationSecurityGroupNames      = optional(list(string))
#         destinationApplicationSecurityGroupNames = optional(list(string))
#       })
#     }))
#   }))
#   description = "The network security groups with their properties."
#   default     = {}
# }

#peering
# variable "sharedservicesnetworkpeering" {
#   type = map(object({
#     sourceVnetName      = string
#     sourceVnetRg        = string
#     destinationVnetName = string
#     destinationVnetRg   = string
#   }))
# }

# variable "sourceVnetName" {
#   type        = string
#   description = "source vnet"
# }

# variable "sourceVnetRg" {
#   type        = string
#   description = "source vEnt RG"
# }

# variable "destinationVnetName" {
#   type        = string
#   description = "destination vnet name"
# }
# variable "destinationVnetRg" {
#   type        = string
#   description = "destination vnet RG"
# }


# variable "disk_encryption_set_name" {
#   type        = string
#   description = "disk encryption set name"
# }

# #SQL Paas
# variable "sharedservicesSQLDB" {
#   description = "The SQL DBs with their properties."
#   type = map(object({
#     resource_group_name = string
#     location            = string
#     serverName          = string
#     administratorLogin  = string
#     databaseName        = string
#     maxSizeGB           = string
#     zoneRedundant       = string
#     licenseType         = string
#     tags                = optional(map(string))
#     emailAddresses      = optional(list(string))
#   }))
# }


# #vm
# variable "sharedservicesJumpBoxVms" {
#   description = "The jump box VMs with their properties."
#   type = map(object({
#     vmName                     = string
#     resourceGroupName          = string
#     subscriptionId             = string
#     computerName               = string
#     osType                     = string
#     vmSize                     = string
#     imagePublisher             = string
#     imageOffer                 = string
#     imageSku                   = string
#     imageVersion               = string
#     createOption               = string
#     diskSizeGB                 = number
#     vmDiskStorageType          = string
#     vmNicSuffix                = string
#     nsgName                    = string
#     ipConfigName               = string
#     privateIPAllocationMethod  = string
#     jumpBoxPrivateIP           = string
#     vNetName                   = string
#     subnetName                 = string
#     availabilityZone           = number
#     encryptionAtHost           = bool
#     diskEncryptionKeyVaultName = string
#     subnetresourceGroupName    = string
#     // managed_data_disks         = map(object({
#     //   lun                   = number
#     //   caching               = string
#     //   write_accelerator_enabled = bool
#     // }))
#   }))
#   default = {}
# }

# // variable "managed_data_disks" {
# //   type = map(object({
# //     disk_name                 = string
# //     vm_key                    = string
# //     location                  = string
# //     resource_group_name       = string
# //     lun                       = string
# //     storage_account_type      = string
# //     disk_size                 = number
# //     caching                   = string
# //     write_accelerator_enabled = bool
# //     create_option             = string
# //     os_type                   = string
# //     source_resource_id        = string
# //     #location            = string
# //     #resource_group_name = string
# //   }))
# //   description = "Map containing storage data disk configurations"
# //   default     = {}
# // }

# variable "adminUser" {
#   description = "value of the admin user"
#   type        = string
#   default     = "adminuser"
# }

# variable "sharedservicesLinuxVms" {
#   description = "A map of Linux VM configurations."
#   type = map(object({
#     vmName                    = string
#     resourceGroupName         = string
#     subscriptionId            = string
#     osType                    = string
#     vmSize                    = string
#     imagePublisher            = string
#     imageOffer                = string
#     imageSku                  = string
#     imageVersion              = string
#     createOption              = string
#     diskSizeGB                = number
#     vmDiskStorageType         = string
#     vmNicSuffix               = string
#     nsgName                   = string
#     ipConfigName              = string
#     privateIPAllocationMethod = string
#     jumpBoxPrivateIP          = string
#     vNetName                  = string
#     subnetName                = string
#     availabilityZone          = number
#     encryptionAtHost          = bool
#     subnetresourceGroupName   = string
#   }))
# }



# variable "resource_group_name" {
#   type        = string
#   description = "The name of the resource group"
# }


# variable "backupVaults" {
#   description = "Backup Vaults"
#   type = map(object({
#     backupvaultname = string
#     redundancy      = string
#     datastore_type  = string
#   }))
#   default = {}

# }

# variable "diskBackupPolicies" {
#   description = "Map of disk backup policies"
#   type = map(object({
#     backup_policy_name               = string
#     backup_vault_Name                = string
#     subscriptionId                   = string
#     location                         = string
#     backupvault_resource_group_name  = string
#     managed_disk_resource_group_name = string
#     snapshot_resource_group_name     = string
#     backup_instance_name             = string
#     vmName                           = string
#     osType                           = string

#   }))

# }

# variable "storagebackupPolicies" {
#   description = "Map of backup policies"
#   type = map(object({
#     backup_policy_name               = string
#     backup_vault_Name                = string
#     vault_default_retention_duration = string
#     shared_sub_id                    = string
#     backup_instance_name             = string
#     location                         = string
#     resource_group_name              = string
#   }))
# }

# #####-------------------------------------------------------------------------------------------

# # Log Analytics (Optional)
# variable "workspaces" {
#   type = map(object({
#     resourceGroupName        = string
#     name                     = string
#     sku                      = string
#     retentionPeriod          = number
#     internetIngestionEnabled = bool
#     internetQueryEnabled     = bool
#     dailyQuotaGb             = number
#   }))
# }

# #dce
# variable "shareddatacollectionendpoint" {
#   description = "A map of data collection endpoints with their attributes."
#   type = map(object({
#     datacollectionendpoint = string
#     resource_group_name    = string
#     location               = string
#     kind                   = string
#   }))
# }

# variable "dce_resource_association" {
#   description = "A map of data collection endpoint resource associations with their attributes."
#   type = map(object({
#     datacollectionendpoint = string
#     target_resource_id     = string

#   }))
# }

# variable "dcr_configs" {
#   description = "Mapping of shared data collection rules with their details."
#   type = map(object({
#     dcr_name                 = string
#     dcr_rg_name              = string
#     dcr_rg_location          = string
#     destination_logworkspace = string
#     dce_name                 = string
#     dce_rg_name              = string
#     data_flow_streams        = list(string)

#     # Windows-specific data sources
#     os_type                          = string
#     datasource_perfcounter           = list(string)
#     datasource_perfCounterSpecifiers = list(string)
#     win_perfcounter_name             = string
#     win_event_log_stream             = list(string)
#     win_path_Query                   = list(string)
#     win_log_name                     = string

#     # Linux-specific data sources
#     linux_log_name         = string
#     linux_event_log_stream = list(string)


#     tags = optional(map(string))
#   }))
# }

# variable "sharedRecoveryServiceVault" {
#   description = "Recovery Service Vault"
#   type = map(object({
#     recovery_services_vault_name = string
#     resource_group_name          = string
#     sku                          = string
#     identity_type                = string
#   }))
#   default = {}
# }

# variable "rsv_rg" {
#   type        = string
#   description = "Recovery Service Vault Resource Group Name"

# }

# variable "diagnostic_logs" {
#   description = "Map of resources (storage accounts, SQL PaaS, etc.) with diagnostic settings configuration."
#   type = map(object({
#     name                           = string
#     target_resource_id             = string
#     storage_account_id             = string
#     log_analytics_workspace_id     = string
#     eventhub_name                  = string
#     eventhub_authorization_rule_id = string
#     logs_categories                = list(string)
#     metrics                        = list(string)
#   }))
# }


# variable "vm_backup_policies" {
#   description = "Map of VM backup policies"
#   type = map(object({
#     backup_policy_name      = string
#     recovery_vault_name     = string
#     rsv_resource_group_name = string
#     backup_frequency        = string
#     backup_time             = string
#     retention_daily_count   = number
#     vm_name                 = string
#     vm_resource_group_name  = string
#   }))
# }


###--------------------------------------------------------------------------------------------------------

####-------------------------------------------------------------------------------------------------------





// # dnszone.
// variable "sharedserviceDNSZones" {
//   description = "The private DNS zones with their properties."
//   type = map(object({
//     name              = string
//     resourceGroupName = string
//     tags              = optional(map(string))
//   }))
//   default = {}
// }



// variable "sharedserviceprivatednsarecord" {
//   type = map(object({
//     name   =  string
//     zone_name = string
//     resource_group_name = string
//     ttl     = number
//     records = list(string)
// }))
// }


