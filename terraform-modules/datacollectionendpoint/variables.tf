variable "name" {
  type = string
  description = "The name of the DCE. Changing this forces a new resource to be created"
}

variable "resource_group_name" {
  type = string
  description = "The name of the resource group in which to create the DCE"
}

variable "location" {
  type = string
  description = "The Azure region where the DCE should exist. Changing this forces a new resource to be created."
}

variable "kind" {
  type = string
  description = "Windows/Linux"
}

variable "public_network_access_enabled" {
  type = bool
  description = "public_network_access_enabled"
  default     = "false"
}




