variable "name"{
    type = string
    description = "name"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
  default = "no_resource_group_name"
}

variable "publisher_name" {
  type = string
  description = "name of publisher"
}

variable "publisher_email" {
  type = string
  description = "publisher email"
}

variable "sku_name" {
  type = string
  description = "sku name"
}
