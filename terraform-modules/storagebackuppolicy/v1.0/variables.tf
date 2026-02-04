variable "vault_default_retention_duration" {
  description = "Default retention duration for the vault"
  type        = string
  
}

variable "backup_policy_name" {
  description = "Name of the backup policy"
  type        = string
}

variable "backup_vault_id" {
  description = "ID of the backup vault"
  type        = string
  
}

variable "backup_instance_name" {
  description = "Name of the backup instance"
  type        = string
}

variable "location" {
  description = "Location of the backup instance"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "backupvaultname" {
  description = "Name of the backup vault"
  type        = string
}



