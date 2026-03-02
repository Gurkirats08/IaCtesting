variable "main_location" {
  type        = string
  description = "Location for deployment"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "public_ip_ids" {
  type = map(any)
}

# -
# - Vnet Gateways
# -
variable "vnet_gateways" {
  description = "The vnet gateways with their properties."
  type = map(object({
    name                       = string
    resourceGroupName          = string
    type                       = string
    vpnType                    = optional(string)
    enableBGP                  = optional(bool)
    gatewaySku                 = string
    vNetName                   = string
    gatewayTags                = optional(map(string))
    gatewayIpConfig            = string
    privateIpAddressAllocation = string
    subscriptionId             = string
  }))
  default = {}
}
