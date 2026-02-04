
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "identity_sub_id" {
  type        = string
  description = "Environment type"
}

variable "adminUser" {
  type        = string
  description = "adminUser"

}

variable "hsm_resource_group" {
  type        = string
  description = "Environment type"
}

variable "hsm_key_name" {
  type        = string
  description = "Environment type"
  
}

variable "sharedservicesLinuxVms" {
  description = "A map of Linux VM configurations."
  type = map(object({
    vmName                    = string
    resourceGroupName         = string
    subscriptionId            = string
    osType                    = string
    vmSize                    = string
    imagePublisher            = string
    imageOffer                = string
    imageSku                  = string
    imageVersion              = string
    createOption              = string
    diskSizeGB                = number
    vmDiskStorageType         = string
    vmNicSuffix               = string
    nsgName                   = string
    ipConfigName              = string
    privateIPAllocationMethod = string
    jumpBoxPrivateIP          = string
    vNetName                  = string
    subnetName                = string
    availabilityZone          = number
    encryptionAtHost          = bool
    subnetresourceGroupName   = string
  }))
}



variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}



# variable "appDataDisks" {
#   description = "Map of data disks to be attached to VMs"
#   type = map(object({
#     resource_group_name  = string
#     disk_name            = string
#     storage_account_type = string
#     disk_size_gb         = number
#   }))
# }

# variable "disk_encryption_set_name" {
#   type        = string
#   description = "disk encryption set name"

# }

# variable "backup_vault_name" {
#   type        = string
#   description = "Storage Account Name for nsg flow logs"

# }

# variable "managedIdentity" {
#   type        = string
#   description = "Environment type"

# }

# variable "hsm_key_name" {
#   type        = string
#   description = "Environment type"
# }

variable "appRecoveryServiceVault" {
  description = "Recovery Service Vault"
  type = map(object({
    recovery_services_vault_name = string
    resource_group_name          = string
    sku                          = string
    identity_type                = string
  }))
  default = {}
}

variable "vm_backup_policies" {
  description = "Map of VM backup policies"
  type = map(object({
    backup_policy_name      = string
    recovery_vault_name     = string
    rsv_resource_group_name = string
    backup_frequency        = string
    backup_time             = string
    retention_daily_count   = number
    vm_name                 = string
    vm_resource_group_name  = string
  }))
}

variable "rsv_rg" {
  type        = string
  description = "Environment type"

}


variable "hsm_name" {
  type        = string
  description = "Environment type"
}

# variable "identityVirtualMachines" {
#   description = "VM with their properties."
#   type = map(object({
#     vmName = string
#     computerName = string 
#     osType = string
#     vmSize = string
#     vNetName = string
#     imagePublisher = string
#     imageOffer = string
#     imageSku = string
#     imageVersion = string
#     createOption = string
#     diskSizeGB = number
#     vmDiskStorageType = string
#     privateIPAllocationMethod = string
#     vmNicSuffix = string
#     ipConfigName = string
#     resourceGroupName = string
#     subnetName  = string
#     subnetresourceGroupName = string
#     availabilityZone = number
#    # disk_encryption_set_id = string
#     encryptionAtHost = bool
#     diskEncryptionKeyVaultName = string
#   }))
#   default = {}
# }

#non cvm
# variable "identityVirtualMachines" {
#   description = "VM with their properties."
#   type = map(object({
#     vmName                    = string
#     computerName              = string
#     osType                    = string
#     vmSize                    = string
#     vNetName                  = string
#     imagePublisher            = string
#     imageOffer                = string
#     imageSku                  = string
#     imageVersion              = string
#     createOption              = string
#     diskSizeGB                = number
#     vmDiskStorageType         = string
#     privateIPAllocationMethod = string
#     vmNicSuffix               = string
#     ipConfigName              = string
#     resourceGroupName         = string
#     subnetName                = string
#     subnetresourceGroupName   = string
#     availabilityZone          = number
#     # disk_encryption_set_id = string
#     encryptionAtHost           = bool
#     diskEncryptionKeyVaultName = string
#   }))
#   default = {}
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
#     //nsgName                   = string
#     ipConfigName              = string
#     privateIPAllocationMethod = string
#     //jumpBoxPrivateIP          = string
#     vNetName                  = string
#     subnetName                = string
#     availabilityZone          = number
#     encryptionAtHost          = bool
#     subnetresourceGroupName   = string
#   }))
# }

# variable "resource_group_name" {
#   type        = string
#   description = "Resource Group Name"

# }

variable "subscriptionId" {
  type        = string
  description = "Subscription ID"

}


# variable "appRecoveryServiceVault" {
#   description = "Recovery Service Vault"
#   type = map(object({
#     recovery_services_vault_name = string
#     resource_group_name          = string
#     sku                          = string
#     identity_type                = string
#   }))
#   default = {}
# }


# variable "security_sub_id" {
#   type        = string
#   description = "Environment type"
# }

# variable "nsgFlowStorageAccountName" {
#   type        = string
#   description = "Storage Account Name for nsg flow logs"
# }

# variable "terraformStorageRG" {
#   type = string
# }

# variable "terraformStorageAccount" {
#   type = string
# }


# variable "idntPrivateEndpoint" {
#   type = map(object({
#     private_endpoint_name          = string
#     subnet_name                    = string
#     vnet_name                      = optional (string)
#     subresource_names              = list(string)
#     storage_account_id             = string
#   }))
# }

# variable "hsmKeyName" {
#   type        = string
#   description = "Environment type"
# }

# variable "hsm_name" {
#   type        = string
#   description = "Environment type"
# }

# variable "hsm_resource_group" {
#   type        = string
#   description = "Environment type"
# }

# variable "network_watcher_name" {
#   description = "Network Watcher Name"
#   type        = string
# }

# variable "network_watcher_rg" {
#   description = "Network Watcher Resource Group"
#   type        = string
# }


variable "resourceGroups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

# variable "idntVirtualNetworks" {
#   description = "Virtual networks"
#   type = map(object({
#     resourceGroupName  = string
#     subscriptionId     = string
#     VirtualNetworkName = string
#     address_space      = string
#     bastionIPName      = string
#     sku_name           = string
#     bastionName        = string
#   }))
#   default = {}
# }

# variable "idntSubnets" {
#   description = "The subnets with their properties."
#   type = map(object({
#     resourceGroupName = string
#     vnet_key          = optional(string)
#     name              = string
#     addressPrefix     = string
#     vnet_name         = string
#     routeTableId      = optional(string)
#     subscriptionId    = optional(string)
#     nsgName           = optional(string)
#     rtName            = optional(string)
#   }))
#   default = {}
# }

# variable "identityDNSLink" {
#   type = map(object({
#     name                  = string
#     resource_group_name   = string
#     private_dns_zone_name = string
#     registration_enabled  = bool
#   }))
# }

# variable "identityNetworkPeering" {
#   type = map(object({
#     sourceVnetName      = string
#     sourceVnetRg        = string
#     destinationVnetName = string
#     destinationVnetRg   = string
#   }))
# }


# # variable "virtual_network" {
# #   type        = string
# #   description = "VNET name"
# # }

# variable "disk_encryption_set_name" {
#   type        = string
#   description = "disk encryption set name"
# }

# # variable "vnet_address_space" {
# #   type        = string
# #   description = "Environment type"
# # }

# variable "idntWorkspace" {
#   type = map(object({
#     name                     = string
#     resourceGroupName        = string
#     sku                      = string
#     retentionPeriod          = optional(number)
#     internetIngestionEnabled = optional(bool)
#     internetQueryEnabled     = optional(bool)
#     dailyQuotaGb             = optional(number)
#   }))
# }

# variable "idntFlowLogs" {
#   description = "Configuration object for NSG Flow Log"
#   type = map(object({
#     nsg_flow_log_name = string
#     nsgName           = string
#     location          = string
#     subscriptionId    = string
#   }))
# }


variable "tags" {
  type        = map(string)
  description = "Environment type"
}

# variable "adminUser" {
#   type        = string
#   description = "adminUser"
# }

variable "location" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

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

# variable "maintenance_configurations" {
#   description = "Map of maintenance configurations with attributes for each configuration."
#   type = map(object({
#     maintenance_configuration_name = string
#     resource_group_name            = string
#     scope                          = string
#     visibility                     = string
#     in_guest_user_patch_mode       = string
#     start_date_time                = string
#     expiration_date_time           = string
#     duration                       = string
#     time_zone                      = string
#     recur_every                    = string
#     linux_classifications          = list(string)
#     linux_excluded_packages        = list(string)
#     linux_included_packages        = list(string)
#     windows_classifications        = list(string)
#     kb_numbers_to_exclude          = list(string)
#     kb_numbers_to_include          = list(string)
#     reboot                         = string
#     tags                           = map(string)
#   }))
# }

# variable "dynamic_scope_maintenance" {
#   type = map(object({
#     maintenance_configuration_name = string
#     dynamic_scope_maintenance_name = string
#     resource_group_name            = string
#     resource_group_names           = list(string)
#   }))
# }

# variable "vm_maintenance_assignments" {
#   type = map(object({
#     maintenance_configuration_name = string
#     resource_group_name            = string
#     vm_resource_group_name         = string
#     vm_name                        = string
#   }))
# }


variable "mainLocation" {
  description = "Default location for all resources."
  type        = string
}


# variable "backup_vault_name" {
#   type        = string
#   description = "Storage Account Name for nsg flow logs"

# }

# variable "identityNetworkSecurityGroups" {
# type = map(object({
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


# variable "identityRouteTables" {
#   type = map(object({
#     resourceGroupName = string
#     routeTableName    = string
#     disableBgpRoutePropagation = bool
#     routes            = list(object({
#       name             = string
#       addressPrefix    = string
#       nextHopType      = string
#       NextHopIpAddress = optional(string)
#     }))
#   }))
#   description = "The route tables with their properties."
#   default     = {} 
# }



# variable "identitySubnets" {
#   description = "The subnets with their properties."
#   type = map(object({
#     name = string
#     vnet_name = string
#     addressPrefixes = list(string)
#   }))
#   default = {}
# }

# ________________________________________
# variable "identityVirtualMachines" {
#   description = "VM with their properties."
#   type = map(object({
#     vmName = string
#     computerName = string 
#     osType = string
#     vmSize = string
#     vNetName = string
#     imagePublisher = string
#     imageOffer = string
#     imageSku = string
#     imageVersion = string
#     createOption = string
#     diskSizeGB = number
#     vmDiskStorageType = string
#     privateIPAllocationMethod = string
#     vmNicSuffix = string
#     ipConfigName = string
#     resourceGroupName = string
#     subnetName  = string
#     subnetresourceGroupName = string
#     availabilityZone = number
#    # disk_encryption_set_id = string
#     encryptionAtHost = bool
#     diskEncryptionKeyVaultName = string
#   }))
#   default = {}
# }

# variable "identity_user_assigned_identity_name" {
#   type        = string
#   description = "name of the user assigned identity"

# }

# variable "backupVaults" {
#   description = "Backup Vaults"
#   type = map(object({
#     backupvaultname = string
#     resource_group_name = string
#     location = string
#     redundancy      = string
#     datastore_type  = string
#   }))
#   default = {}

# }
# variable "security_subsId" {
#   type        = string
#   description = "Subscription ID"

# }

# variable "terraformStorageRG" {
#   type = string
# }

# variable "terraformStorageAccount" {
#   type = string
# }


# variable "storagebackupPolicies" {
#   description = "Map of backup policies"
#   type = map(object({
#     backup_policy_name               = string
#     backup_vault_Name                = string
#     vault_default_retention_duration = string
#     identity_sub_id                  = string
#     backup_instance_name             = string
#     location                         = string
#     resource_group_name              = string
#   }))
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
#     backup_policy_name = string
#     backup_vault_Name                = string
#     identity_sub_id                   = string
#   }))

# }

# # Resource lock
# variable "idntResourceLocks" {
#   description = "Resource Locks"
#   type = map(object({
#     resource_name       = optional(string)
#     name                = string
#     lock_level          = string
#     notes               = string
#     resource_type       = optional(string)
#     resource_group_name = string
#   }))
#   default = {}

# }

# storage account
# variable "storageAccounts" {
#   description = "Storage Accounts"
#   type = map(object({
#     name                      = string
#     account_tier              = string
#     account_replication_type  = string
#     resource_group_name       = string
#     location                  = string
#     shared_access_key_enabled = optional(bool)

#   }))
#   default = {}
# }

/*
variable "connHSM" {
  description = "HSM variables"
  type = object({
    name                = string
    resource_group_name = string
  })
  default = {
    name                = ""
    resource_group_name = ""
  }
} */


# variable "idntdatacollectionendpoint" {
#   description = "A map of data collection endpoints with their attributes."
#   type = map(object({
#     datacollectionendpoint = string # The name of the Data Collection Endpoint
#     resource_group_name    = string # The name of the Resource Group
#     location               = string # The Azure region
#     kind                   = string # The kind of the Data Collection Endpoint
#   }))
# }

# variable "dcr_configs" {
#   description = "Mapping of shared data collection rules with their details."
#   type = map(object({
#     dcr_name        = string
#     dcr_rg_name     = string
#     dcr_rg_location = string
#     # datacollectionendpoint   = string # Reference to the data collection endpoint
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
