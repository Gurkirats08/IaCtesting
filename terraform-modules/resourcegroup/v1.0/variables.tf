variable "resource_group_name" {
  type        = string
  description = "The resource group name."
}

variable "location" {
  type        = string
  description = "The region were the resource will be deployed."
}

variable "tags" {
  type    = map(string)
  default = null
}
