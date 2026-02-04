variable "name" {
  type = string
  description = "name"
}

variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "private_dns_zone" {
  type = string
  description = "private dns zone"
}

variable "virtual_network_id" {
  type = string
  description = "virtual network id"
}

variable "registration_enabled" {
  type        = bool
  description = "Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabledegistration enabled?"
}
