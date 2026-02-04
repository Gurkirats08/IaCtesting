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
# variable "public_IPs" {
#   type = map(object({
#     bastionIPName              = optional(string)
#     firewallIPName             = optional(string)
#     resourceGroupName          = string
#     publicIPAllocationMethod   = optional(string)
#     firewallIpAllocationMethod = optional(string)
#     zones                      = optional(list(string))
#     publicIPAddressVersion     = optional(string)
#     skuName                    = optional(string)
#     firewallSkuName            = optional(string)
#   }))
#   description = "The public IP with their properties."
#   default     = {}
# }

variable "public_IPs" {
  type = map(object({
    bastionIPName              = optional(string)
    firewallIPName             = optional(string)
    gatewayIPName              = optional(string)
    publicIPAllocationMethod   = optional(string)
    firewallIpAllocationMethod = optional(string)
    gatewayIpAllocationMethod  = optional(string)
    skuName                    = optional(string)
    firewallSkuName            = optional(string)
    gatewayipSku               = optional(string)
    zones                      = optional(list(string))
    publicIPAddressVersion     = optional(string)
    resourceGroupName          = optional(string)
  }))
}


variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the public IP will be created."

}
