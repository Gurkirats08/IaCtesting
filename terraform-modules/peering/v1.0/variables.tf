# variable "sourceSubscriptionId" {
#   type = string
# }

# variable "destinationSubscriptionId" {
#   type = string
# }

variable "sourceVnetName" {
  type = string
}

variable "sourceVnetRg" {
  type = string
}

variable "destinationVnetName" {
  type = string
}

variable "destinationVnetRg" {
  type = string
}

variable "allowVirtualNetworkAccess" {
  type    = bool
  default = null
}

variable "allowForwardedTraffic" {
  type    = bool
  default = null
}

variable "allowGatewayTransit" {
  type    = bool
  default = null
}

variable "useRemoteGateways" {
  type    = bool
  default = null
}
