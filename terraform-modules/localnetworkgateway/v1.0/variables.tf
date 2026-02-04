variable "main_location" {
  type = string
}

variable "environment" {
  type = string
}

variable "local_network_gateways" {
  type = map(object({
    name                = string
    resource_group_name = string
    gateway_address     = string
    address_space       = list(string)
    tags                = optional(map(string))
  }))
  description = "Map of local network gateway"
}