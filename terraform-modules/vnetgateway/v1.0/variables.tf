variable "location" {
  type        = string
  description = "Location for deployment"
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."

}

# -
# - Vnet Gateways
# -
variable "vnet_gateways" {
  description = "The vnet gateways with their properties."
  type = map(object({
    VnetGatewayName            = string
    resourceGroupName          = string
    type                       = string
    vpnType                    = optional(string)
    enableBGP                  = optional(bool)
    gatewaySkuName             = string
    vnetName                   = string
    gatewayTags                = optional(map(string))
    privateIpAddressAllocation = string
    subscriptionId             = string
    subnetRG                   = string
    publicipRG                 = string
    gatewayIPName              = string
  }))
  default = {}
}
