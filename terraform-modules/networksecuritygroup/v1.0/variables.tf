variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the NSGs."
  default     = null
}

variable "main_location" {
  type        = string
  description = "Resource deployment location."
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "nsg_additional_tags" {
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
# - Network Security Group object
# -
variable "network_security_groups" {
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

variable "log_analytics_workspace_id" {
  type        = string
  description = "log analytic workspace id"
  default     = null
}

variable "log_analytics_workspace_resourceid" {
  type        = string
  description = "log analytic workspace resource id"
  default     = null
}

variable "network_watcher_name" {
  type        = string
  description = "Network watcher name"
  default     = null
}

variable "flowlog_storage_resourceid" {
  type        = string
  description = "Resourceid of storage account where flowlog data will be saved."
  default     = null
}

variable "enable_diagnostic_log" {
  type        = bool
  description = "Enable or disable diagnostics logs"
  default     = false
}

variable "enable_flow_log" {
  type        = bool
  description = "Enable or disable network watcher flow logs"
  default     = false
}
