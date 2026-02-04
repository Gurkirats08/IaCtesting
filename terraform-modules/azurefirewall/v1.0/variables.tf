variable "location" {
  type        = string
  description = "Location for deployment"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "firewall_additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Azure Firewall will be created."  
}

variable "firewall_policy_ids" {
  type = map(any)
}

variable "firewall_ip_ids" {
  type = map(any)
}

variable "firewalls" {
  type = map(object({
    firewallName               = string
    threatIntelMode            = string
    firewallSkuName            = string
    firewallSkuTier            = string
    vNetName                   = string
    resourceGroupName          = string
    subscriptionId             = optional(string)
    firewallIPName             = string
    firewallIpAllocationMethod = string
    firewallPolicyName         = string
    firewallPolicyTier         = string
    zones                      = optional(list(number))
    firewallPolicyRuleCollectionGroups = optional(list(object({
      name     = optional(string)
      priority = optional(number)
      ruleCollections = optional(list(object({
        ruleCollectionType = string
        action = object({
          type = string

        })
        rules = optional(list(object({
          ruleType = string
          name     = string
          protocols = list(object({
            protocolType = string
            port         = number
          })),
          targetFqdns     = optional(list(string))
          terminateTLS    = optional(bool)
          sourceAddresses = optional(list(string))
        })))
      })))

    })))
    # ip_configurations = list(object({
    #   name                      = string
    #   subnet_name               = string
    #   vnet_name                 = string
    #   networking_resource_group = string
    # }))
  }))
  description = "The Azure Firewalls with their properties."
  default     = {}
}

variable "fw_network_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name                  = string
      description           = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      destination_addresses = list(string)
      protocols             = list(string)
    }))
  }))
  description = "The Azure Firewall Rules with their properties."
  default     = {}
}

variable "fw_nat_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    rules = list(object({
      name               = string
      description        = string
      source_addresses   = list(string)
      destination_ports  = list(string)
      protocols          = list(string)
      translated_address = string
      translated_port    = number
    }))
  }))
  description = "The Azure Firewall Nat Rules with their properties."
  default     = {}
}

variable "fw_application_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name             = string
      description      = string
      source_addresses = list(string)
      fqdn_tags        = list(string)
      target_fqdns     = list(string)
      protocol = list(object({
        port = number
        type = string
      }))
    }))
  }))
  description = "The Azure Firewall Application Rules with their properties."
  default     = {}
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
