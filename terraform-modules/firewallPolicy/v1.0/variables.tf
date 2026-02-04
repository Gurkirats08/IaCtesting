variable "main_location" {
  type        = string
  description = "Location for deployment"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "public_ip_additional_tags" {
  type        = map(string)
  description = "Additional Network Security Group resources tags, in addition to the resource group tags."
  default     = {}
}

###### Skip Provider Variables ######
variable "skip_provider_registration" {
  type        = bool
  description = "The skip provider registation flag."
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "The ID of the subscription to which provider skip is needed."
  default     = null
}

# -
# - Public IP object
# -
variable "firewall_policy" {
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
        name     = optional(string)
        priority = number
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
  }))
  description = "The public IP with their properties."
  default     = {}
}
