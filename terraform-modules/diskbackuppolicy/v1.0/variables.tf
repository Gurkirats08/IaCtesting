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

variable "backupvault_resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "backupvaultname" {
  description = "Name of the backup vault"
  type        = string
}


variable "snapshot_resource_group_name" {
  description = "Name of the resource group for the snapshot"
  type        = string
  
}

variable "managed_disk_name" {
  description = "Name of the managed disk"
  type        = string
  
}

variable "managed_disk_resource_group_name" {
  description = "Name of the resource group for the managed disk"
  type        = string
  
}
