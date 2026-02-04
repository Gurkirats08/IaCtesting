variable "name" {
  type = string
  description = "cosmo dn acocunt name"
}

variable "location" {
  type = string
  description = "location"
}

variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "offer_type" {
  type = string
  description = "offer type"
}

variable "consistency_level" {
  type = string
  description = "consistency level"
}

variable "geo_location" {
  type = string
  description = "geo location"
}

variable "failover_priority" {
  type = number
  description = "failover priority"
}