variable "name" {
    type = string
    description = "name"
}

variable "zone_name" {
  type = string
  description = "zone name"
}

variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "ttl" {
  type = number
  description = "ttl"
  default = 3600
}

variable "records" {
  type = list(string)
  description = "records"
}