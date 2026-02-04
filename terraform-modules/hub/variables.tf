variable "prefix-hub" {
  description = "Prefix for hub resources"
  type        = string
  default     = "hub"
}

variable "hub-location" {
  description = "Location for hub resources"
  type        = string
  default     = "eastus"
}

variable "hub-resource-group" {
  description = "Resource group for hub resources"
  type        = string
  default     = "hub-rg"
}
variable "deploy_hub" {
  type    = bool
  default = false
}
variable "enabled" {
  type    = bool
  default = false
}
variable "address_prefix_hubvnet" {
  type    = string
  default = ""
}
variable "address_prefix_hub" {
  type    = string
  default = ""
}
variable "address_space" {
  type    = string
  default = "10.0.0.0/16"
}
variable "deploy_hub_resource_group" {
  type    = bool
  default = false
}
variable "deploy_hub_vnets" {
  type    = bool
  default = false
}
variable "deploy_hub_subnets" {
  type    = bool
  default = false
}