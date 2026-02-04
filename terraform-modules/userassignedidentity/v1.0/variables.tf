variable "location" {
  type        = string
  description = "The location/region where the user-assigned identity will be created."
}

variable "name" {
  type        = string
  description = "The name for the user-assigned identity. Must be unique within the Azure resource group."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the user-assigned identity will be created."
}
