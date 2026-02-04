# Global Variables
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "HSM" {
  description = "HSM variables"
  type = object({
    name        = string
    hsm_rg_name = string
  })
  default = {
    name        = ""
    hsm_rg_name = ""
  }
}

variable "hsm_key_name" {
  type        = string
  description = "HSM Key Name"

}

variable "nsgFlowStorageAccountName" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

variable "userAssignedIdentityName" {
  type = map(object({
    uai_name            = string
    location            = string
    resource_group_name = string
  }))
  description = "User Assigned Identity Name"
}

variable "mainLocation" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}


variable "commonResourceGroupName" {
  description = "Resource group name of the storage account"
  type        = string
}

variable "mgmtSubscriptionId" {
  description = "Management Subscription ID"
  type        = string
}

variable "network_watcher_name" {
  description = "Network Watcher Name"
  type        = string
}

variable "network_watcher_rg" {
  description = "Network Watcher Resource Group"
  type        = string

}

# Mgmt Resource Group
variable "resourceGroups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

# mgmt Resource lock
variable "mgmtResourceLocks" {
  description = "Resource Locks"
  type = map(object({
    resource_name       = optional(string)
    name                = string
    lock_level          = string
    notes               = string
    resource_type       = optional(string)
    resource_group_name = string
  }))
  default = {}

}

#ddos
variable "mgmtddos" {
  description = "The DDoS plans with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}
}

# Virtual Network
variable "mgmtVirtualNetworks" {
  description = "Virtual networks"
  type = map(object({
    resourceGroupName  = string
    subscriptionId     = string
    VirtualNetworkName = string
    address_space      = string
    sku_name           = string
    DDosProtectionPlan = string
  }))
  default = {}
}


variable "mgmtRouteTables" {
  type = map(object({
    resourceGroupName             = string
    routeTableName                = string
    bgp_route_propagation_enabled = bool
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


variable "mgmtNetworkSecurityGroups" {
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

variable "mgmtSubnets" {
  description = "The subnets with their properties."
  type = map(object({
    resourceGroupName = string
    vnet_key          = string
    name              = string
    addressPrefix     = string
    vnet_name         = string
    subscriptionId    = optional(string)
    nsgName           = optional(string)
    rtName            = optional(string)
  }))
  default = {}
}
variable "private_endpoint_network_policies" {
  type = string
}


variable "mgmtPrivateEndpoint" {
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

variable "backupVaultName" {
  type        = string
  description = "Backup Vault Name"

}

variable "uai_name" {
  type        = string
  description = "User Assigned Identity Name"

}


variable "mgmtNetworkPeering" {
  type = map(object({
    sourceVnetName      = string
    sourceVnetRg        = string
    destinationVnetName = string
    destinationVnetRg   = string
  }))
}

variable "mgmtDNSLink" {
  type = map(object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    registration_enabled  = bool
  }))
}

# variable "shared_subsId" {
#   type = string
# }

variable "mgmtFlowLogs" {
  description = "Configuration object for NSG Flow Log"
  type = map(object({
    nsg_flow_log_name = string
    nsgName           = string
    location          = string
    subscriptionId    = string
  }))
}

variable "security_law_rg" {
  type        = string
  description = "Log Analytics Workspace Resource Group"

}

variable "security_law_name" {
  type        = string
  description = "Log Analytics Workspace Name"

}

variable "backupVaults" {
  description = "Backup Vaults"
  type = map(object({
    backupvaultname = string
    redundancy      = string
    datastore_type  = string
  }))
  default = {}

}

variable "storagebackupPolicies" {
  description = "Map of backup policies"
  type = map(object({
    backup_policy_name               = string
    backup_vault_Name                = string
    vault_default_retention_duration = string
    mgmt_sub_id                      = string
    backup_instance_name             = string
    location                         = string
    resource_group_name              = string
  }))
}

variable "terraformStorageRG" {
  type = string
}

variable "terraformStorageAccount" {
  type = string
}

variable "security_subsId" {
  type = string
}

variable "automation_accounts" {
  description = "A map of Automation Accounts configurations"
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    sku                          = string
    local_authentication_enabled = bool
    tags                         = optional(map(string), {})
  }))
}


variable "maintenance_configurations" {
  description = "Map of maintenance configurations with attributes for each configuration."
  type = map(object({
    maintenance_configuration_name = string
    resource_group_name            = string
    scope                          = string
    visibility                     = string
    in_guest_user_patch_mode       = string
    start_date_time                = string
    expiration_date_time           = string
    duration                       = string
    time_zone                      = string
    recur_every                    = string
    linux_classifications          = list(string)
    linux_excluded_packages        = list(string)
    linux_included_packages        = list(string)
    windows_classifications        = list(string)
    kb_numbers_to_exclude          = list(string)
    kb_numbers_to_include          = list(string)
    reboot                         = string
    tags                           = map(string)
  }))
}

variable "dynamic_scope_maintenance" {
  type = map(object({
    maintenance_configuration_name = string
    dynamic_scope_maintenance_name = string
    resource_group_name            = string
    resource_group_names           = list(string)
  }))
}

variable "vm_maintenance_assignments" {
  type = map(object({
    maintenance_configuration_name = string
    resource_group_name            = string
    virtual_machine_id             = string
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
