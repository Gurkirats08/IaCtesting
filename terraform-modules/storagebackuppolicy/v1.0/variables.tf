variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
}

variable "location" {
  description = "Location of the resource"
  type        = string
}

variable "backup_vault_name" {
  description = "Name of the backup vault"
  type        = string
}

variable "backup_resource_group_name" {
  description = "Name of the backup resource group"
  type        = string
}

variable "backup_policy_name" {
  description = "Name of the backup policy"
  type        = string
}

variable "backup_instance_name" {
  description = "Name of the backup instance"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
  
}

variable "backup_vault_id" {
  description = "ID of the backup vault"
  type        = string
  
}



