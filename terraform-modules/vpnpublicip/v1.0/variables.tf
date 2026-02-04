variable "main_location" {
  type = string
}

variable "environment" {
  type = string
}

# -
# - Public IP
# -
variable "vpn_ips" {
  description = "The IPS with their properties."
  type = map(object({
    vpnIpName          = string
    resourceGroupName  = string
    ipAllocationMethod = string
    ipSku              = string
    ipTags             = optional(map(string))
  }))
  default = {}
}
