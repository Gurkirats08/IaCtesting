variable "resource_group_name" {
  description = "The name of the resource group in which to create the SQL Server."
  type        = string
}

variable "location" {
  description = "The location of the resource group in which to create the SQL Server."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login for the SQL Server."
  type        = string
}

variable "server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "database_name" {
  description = "The name of the SQL Database."
  type        = string
}


variable "license_type" {
  description = "The license type of the SQL Database."
  type        = string
}

variable "max_size_gb" {
  description = "The maximum size of the SQL Database in gigabytes."
  type        = number
}

variable "zone_redundant" {
  description = "Whether the SQL Database is zone redundant."
  type        = bool
}

variable "tags" {
  type        = map(string)
  description = "Tags of the application security group"
  default     = null
}

variable "email_addresses" {
  type        = list(string)
  description = "Tags of the application security group"
}

# variable "storage_account_name" {
#   description = "The name of the storage account."
#   type        = string
# }

# variable "storage_account_rg" {
#   description = "The name of the resource group in which the storage account is located."
#   type        = string
# }

# variable "container_name" {
#   description = "The name of the storage container."
#   type        = string
# }