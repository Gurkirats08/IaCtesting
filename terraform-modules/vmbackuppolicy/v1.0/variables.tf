variable "recovery_vault_name" {
  description = "Name of the existing Recovery Services Vault"
  type        = string
}

variable "backup_policy_name" {
  description = "Name of the backup policy"
  type        = string
}

variable "backup_frequency" {
  description = "Frequency of VM backup"
  type        = string
  default     = "Daily"
}

variable "backup_time" {
  description = "Time when backup should occur"
  type        = string
  default     = "23:00"
}

variable "retention_daily_count" {
  description = "Number of days to retain daily backups"
  type        = number
  default     = 10
}

variable "vm_name" {
  description = "Name of the virtual machine to be backed up"
  type        = string
}

variable "vm_resource_group_name" {
  description = "Resource group name where the VM exists"
  type        = string
}

variable "rsv_resource_group_name" {
  description = "Resource group name where the Recovery Services Vault exists"
  type        = string
  
}
