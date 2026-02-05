# Global Variables
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "securityuan" {
  type        = string
  description = "uan name in security ALZ"
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

variable "securityResourceLocks" {
  description = "Resource Locks"
  type = map(object({
    name                = string
    lock_level          = string
    notes               = string
    resource_group_name = string
    resource_name       = optional(string)
    resource_type       = optional(string)
  }))
  default = {}

}

variable "hsmPrivateEndpoint" {
  type = map(object({
    private_endpoint_name          = string
    resource_group_name            = string
    location                       = string
    subnet_id                      = string
    private_connection_resource_id = string
    subresource_names              = list(string)
    private_dns_zone_id            = string
  }))
}



# Resource Group
variable "storageAccounts" {
  description = "Storage Accounts"
  type = map(object({
    name                      = string
    account_tier              = string
    account_replication_type  = string
    resource_group_name       = string
    location                  = string
    shared_access_key_enabled = bool
  }))
  default = {}
}




variable "mainLocation" {
  type        = string
  description = "Resource Location"
}

#ddos
variable "SecurityDDos" {
  description = "The DDoS plans with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}
}

# Virtual Network
variable "secVirtualNetworks" {
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

# Key Vault
variable "secKeyVaults" {
  description = "Key Vaults"
  type = map(object({
    name     = string
    location = string
    sku      = string
  }))
  default = {}
}

variable "secRouteTables" {
  type = map(object({
    resourceGroupName         = string
    routeTableName            = string
    enableBgpRoutePropagation = bool
    routes = list(object({
      name             = string
      addressPrefix    = string
      nextHopType      = string
      NextHopIpAddress = optional(string)
    }))
  }))
  description = "The route tables with their properties."
  default     = {}
}

variable "secNetworkSecurityGroups" {
  type = map(object({
    name              = string
    tags              = optional(map(string))
    resourceGroupName = string
    securityRules = list(object({
      name        = string
      description = optional(string)
      properties = object({
        protocol                                 = string
        direction                                = string
        access                                   = string
        priority                                 = number
        sourceAddressPrefix                      = optional(string)
        sourceAddressPrefixes                    = optional(list(string))
        destinationAddressPrefix                 = optional(string)
        destinationAddressPrefixes               = optional(list(string))
        sourcePortRange                          = optional(string)
        sourcePortRanges                         = optional(list(string))
        destinationPortRange                     = optional(string)
        destinationPortRanges                    = optional(list(string))
        sourceApplicationSecurityGroupNames      = optional(list(string))
        destinationApplicationSecurityGroupNames = optional(list(string))
      })
    }))
  }))
  description = "The network security groups with their properties."
  default     = {}
}

variable "secSubnets" {
  description = "The subnets with their properties."
  type = map(object({
    resourceGroupName = string
    vnet_key          = string
    name              = string
    addressPrefix     = string
    vnet_name         = string
    nsgName           = optional(string)
    routeTableId      = string
    subscriptionId    = optional(string)
  }))
  default = {}
}


variable "secJumpBoxVms" {
  description = "The jump box VMs with their properties."
  type = map(object({
    vmName                     = string
    resourceGroupName          = string
    subscriptionId             = string
    computerName               = string
    osType                     = string
    vmSize                     = string
    imagePublisher             = string
    imageOffer                 = string
    imageSku                   = string
    imageVersion               = string
    createOption               = string
    diskSizeGB                 = number
    vmDiskStorageType          = string
    vmNicSuffix                = string
    nsgName                    = string
    ipConfigName               = string
    privateIPAllocationMethod  = string
    jumpBoxPrivateIP           = string
    vNetName                   = string
    subnetName                 = string
    availabilityZone           = number
    encryptionAtHost           = bool
    diskEncryptionKeyVaultName = string
    subnetresourceGroupName    = string
  }))
  default = {}
}

variable "adminUser" {
  description = "value of the admin user"
  type        = string
  default     = "adminuser"
}

# variable "storageAccountResourceGroupName" {
#   description = "Resource group name of the storage account"
#   type        = string
#   default     = ""
# }

# variable "storageAccountName" {
#   description = "Storage Account Name for nsg flow logs"
#   type        = string
#   default     = "phinsgflowlogs"

# }

# variable "private_dns_zone_name" {
#   type        = string
#   description = "Private DNS Zone"
# }

# variable "dnszone_resource_group_name" {
#   type        = string
#   description = "RG for dns zone"
# }

# Private Endpoint
variable "secPrivateEndpoint" {
  description = "Private Endpoint"
  type = map(object({
    private_endpoint_name          = string
    resource_group_name            = string
    subresource_names              = list(string)
    private_connection_resource_id = string
    private_dns_zone_id            = string
    subnet_id                      = string
  }))
  default = {}
}

# Disk Encryption Set
variable "secDiskEncryptionSet" {
  description = "Disk Encryption Set"
  type = map(object({
    resourceGroupName        = string
    disk_encryption_set_name = string
  }))
  default = {}
}

variable "secWorkspace" {
  type = map(object({
    name                     = string
    resourceGroupName        = string
    sku                      = string
    retentionPeriod          = optional(number)
    internetIngestionEnabled = optional(bool)
    internetQueryEnabled     = optional(bool)
    dailyQuotaGb             = optional(number)
  }))
}

variable "secRbacs" {
  type = map(object({
    resource_name        = string
    role_definition_name = string
    subscriptionId       = string
    provider             = string
    resource_type        = string
  }))
}

variable "secVnetPeering" {
  type = map(object({
    sourceVnetName      = string
    sourceVnetRg        = string
    destinationVnetName = string
    destinationVnetRg   = string
  }))
}

variable "secDNSLink" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    registration_enabled  = bool
  }))
}

# variable "sourceVnetName" {
#   type        = string
#   description = "Source Vnet Name"

# }

# variable "destinationVnetName" {
#   type        = string
#   description = "Destination Vnet Name"

# }

# variable "sourceVnetRg" {
#   type        = string
#   description = "Source Vnet Resource Group"

# }

# variable "destinationVnetRg" {
#   type        = string
#   description = "Destination Vnet Resource Group"

# }

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
}

variable "storagebackupPolicies" {
  description = "Map of backup policies"
  type = map(object({
    backup_policy_name               = string
    backup_vault_Name                = string
    vault_default_retention_duration = string
    sec_sub_id                       = string
    backup_instance_name             = string
    location                         = string
    resource_group_name              = string
  }))
}

variable "subscriptionId" {
  type        = string
  description = "Subscription ID"

}

variable "backupVaultName" {
  description = "Backup Vault Name"
  type        = string

}

variable "diskBackupPolicies" {
  description = "Map of disk backup policies"
  type = map(object({
    backup_policy_name               = string
    backup_vault_Name                = string
    subscriptionId                   = string
    location                         = string
    backupvault_resource_group_name  = string
    managed_disk_resource_group_name = string
    snapshot_resource_group_name     = string
    backup_instance_name             = string
    vmName                           = string
    osType                           = string

  }))

}

variable "hsm_key_name" {
  type        = string
  description = "The name of the HSM Key"

}


variable "key_vault_key_name" {
  type        = string
  description = "The name of the Key Vault Key"

}


variable "subscriptionId" {
  type        = string
  description = "Subscription ID"
}


variable "connFlowLog" {
  description = "Configuration object for NSG Flow Log"
  type = object({
    nsg_flow_log_name = string
    nsgId             = string
    location          = string
  })
}


variable "network_watcher_name" {
  description = "Network Watcher Name"
  type        = string
}

variable "network_watcher_rg" {
  description = "Network Watcher Resource Group"
  type        = string
}

variable "nsgFlowstorageAccountName" {
  type        = string
  description = "Storage Account Name for nsg flow logs"

}

variable "nsgFlowstorageAccountResourceGroupName" {
  type        = string
  description = "Storage Account Name for nsg flow logs"

}


variable "securitydatacollectionendpoint" {
  description = "A map of data collection endpoints with their attributes."
  type = map(object({
    datacollectionendpoint = string
    resource_group_name    = string
    location               = string
    kind                   = string
  }))
}

variable "dce_resource_association" {
  description = "A map of data collection endpoint resource associations with their attributes."
  type = map(object({
    datacollectionendpoint = string
    target_resource_id     = string

  }))
}

variable "dcr_configs" {
  description = "Mapping of shared data collection rules with their details."
  type = map(object({
    dcr_name                 = string
    dcr_rg_name              = string
    dcr_rg_location          = string
    destination_logworkspace = string
    dce_name                 = string
    dce_rg_name              = string
    data_flow_streams        = list(string)

    # Windows-specific data sources
    os_type                          = string
    datasource_perfcounter           = list(string)
    datasource_perfCounterSpecifiers = list(string)
    win_perfcounter_name             = string
    win_event_log_stream             = list(string)
    win_path_Query                   = list(string)
    win_log_name                     = string

    # Linux-specific data sources
    linux_log_name         = string
    linux_event_log_stream = list(string)


    tags = optional(map(string))
  }))
}


variable "secRecoveryServiceVault" {
  description = "Recovery Service Vault"
  type = map(object({
    recovery_services_vault_name = string
    resource_group_name          = string
    sku                          = string
    identity_type                = string
  }))
  default = {}
}

variable "rsv_rg" {
  type        = string
  description = "Recovery Service Vault Resource Group Name"

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

variable "diagnostic_logs" {
  description = "Map of resources (storage accounts, SQL PaaS, etc.) with diagnostic settings configuration."
  type = map(object({
    name                           = string
    target_resource_id             = string
    storage_account_id             = string
    log_analytics_workspace_id     = string
    eventhub_name                  = string
    eventhub_authorization_rule_id = string
    logs_categories                = list(string)
    metrics                        = list(string)
  }))
}


