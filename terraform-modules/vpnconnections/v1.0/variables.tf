variable "main_location" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpn_connections" {
  type = map(object({
    name                    = string
    resource_group_name     = string
    virtual_network_gateway = string
    local_network_gateway   = string
    type                    = string
    shared_key              = string
    tags                    = map(string)
  }))
}