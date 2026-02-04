variable "name" {
  type = string
  description = "name"
}

variable "resource_group_name" {
  type = string
  description = "resource group name"
}

variable "account_name" {
  type = string
  description = "account name"
}

variable "database_name" {
  type = string
  description = "database name"
}

variable "partition_key_paths" {
   type = list(string)
   description = "partition key paths"
}

variable "partition_key_version" {
  type = number
  description = "The version of the partition key definition to use."
  default = 2
}
