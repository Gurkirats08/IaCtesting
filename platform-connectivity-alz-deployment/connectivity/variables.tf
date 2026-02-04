# Global Variables
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "mainLocation" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

variable "resourceGroups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

variable "connSubscriptionId" {
  type        = string
  description = "Subscription ID"
  
}

variable "connNetworkSecurityGroups" {
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

variable "connVirtualNetworks" {
  description = "Virtual networks"
  type = map(object({
    resourceGroupName  = string
    subscriptionId     = string
    VirtualNetworkName = string
    address_space      = string
    bastionIPName      = string
    sku_name           = string
    bastionName        = string
    bastion_sku        = optional(string)
    # DDosProtectionPlan = string
  }))
  default = {}
}

variable "connSubnets" {
  description = "The subnets with their properties."
  type = map(object({
    resourceGroupName = string
    vnet_key          = string
    name              = string
    addressPrefix     = string
    vnet_name         = string
    subscriptionId    = optional(string)
    nsgName           = optional(string)
    routeTableName    = optional(string)
  }))
  default = {}
}

variable "connFirewalls" {
  description = "The firewalls with their properties."
  type = map(object({
    firewallName               = string
    firewallSkuTier            = string
    vNetName                   = string
    resourceGroupName          = string
    subscriptionId             = string
    firewallIPName             = string
    firewallIpAllocationMethod = string
    firewallSkuName            = string
    zones                      = list(number)
    firewallPolicyName         = string
    firewallPolicyTier         = string
    threatIntelMode            = string
    firewallPolicyRuleCollectionGroups = list(object({
      name     = string
      priority = number
      ruleCollections = list(object({
        ruleCollectionType = string
        action = object({
          type = string
        })
        rules = list(object({
          ruleType = string
          name     = string
          protocols = list(object({
            protocolType = string
            port         = number
          }))
          terminateTLS    = bool
          targetFqdns     = list(string)
          sourceAddresses = list(string)
        }))
        name     = string
        priority = number
      }))
    }))

  }))
  default = {}
}

variable "connRouteTables" {
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

variable "subnetRG" {
  type        = string
  description = "Resource group name of the subnet"
  default     = ""

}

# variable "connRbacs" {
#   type = map(object({
#     resource_name        = string
#     role_definition_name = string
#     subscriptionId       = string
#     provider             = string
#     resource_type        = string
#   }))
# }

variable "nsgFlowstorageAccountName" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

variable "nsgFlowstorageAccountResourceGroupName" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

variable "security_law_rg" {
  type        = string
  description = "Log Analytics Workspace Resource Group"

}

variable "security_law_name" {
  type        = string
  description = "Log Analytics Workspace Name"

}

variable "connPrivateEndpoint" {
  type = map(object({
    private_endpoint_name          = string
    resource_group_name            = string
    location                       = string
    subnet_id                      = string
    private_dns_zone_id            = string
    private_connection_resource_id = string
    subresource_names              = list(string)
  }))
}


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

variable "connFlowLog" {
  description = "Configuration object for NSG Flow Log"
  type = object({
    nsg_flow_log_name = string
    nsgId             = string
    location          = string
  })
}

variable "subscriptionId" {
  type        = string
  description = "Subscription ID"

}

variable "connDDos" {
  description = "The DDoS plans with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}
}

variable "connPrivateDNSZones" {
  description = "The private DNS zones with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}

}

variable "network_watcher_name" {
  type        = string
  description = "Network watcher name"
  
}

variable "network_watcher_rg" {
  type        = string
  description = "Network watcher resource group"
  
}

variable "hsmKeyName" {
  type        = string
  description = "The name of the HSM key"

}

variable "connIdentity" {
  type = string
  description = "The managed identity"
}

variable "backupVaultName" {
  type        = string
  description = "The name of the backup vault"
  
}

variable "storagebackupPolicies" {
  description = "Map of backup policies"
  type = map(object({
    backup_policy_name               = string
    backup_vault_Name                = string
    vault_default_retention_duration = string
    conn_sub_id                  = string
    backup_instance_name             = string
    location                         = string
    resource_group_name              = string
  }))
}


variable "connDDos" {
  description = "The DDoS plans with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}
}


variable "security_subsId" {
  type        = string
  description = "Subscription ID"

}

variable "terraformStorageRG" {
  type = string
}

variable "terraformStorageAccount" {
  type = string
}

variable "connResourceLocks" {
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


