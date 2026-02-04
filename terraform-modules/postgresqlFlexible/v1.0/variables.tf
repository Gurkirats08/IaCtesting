variable "name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server"
}

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "zone" {
  type        = string
  description = "Availability Zone"
  default     = null
}

variable "version" {
  type        = string
  description = "PostgreSQL Version"
}

variable "sku_name" {
  type        = string
  description = "SKU Name (e.g. GP_Standard_D2s_v3)"
}

variable "storage_mb" {
  type        = number
  description = "Storage in MB"
}

variable "storage_tier" {
  type        = string
  description = "Storage IOPS tier"
  default     = null
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Enable storage auto-grow"
  default     = false
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days"
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enable geo-redundant backup"
  default     = false
}

variable "create_mode" {
  type        = string
  description = "Create mode"
  default     = "Default"
}

variable "backup_type" {
  type        = string
  description = "Backup type (used to determine if create_mode should be set)"
  default     = null
}

variable "source_server_id" {
  type    = string
  default = null
}

variable "point_in_time_restore_time_in_utc" {
  type    = string
  default = null
}

variable "delegated_subnet_id" {
  type    = string
  default = null
}

variable "private_dns_zone_id" {
  type    = string
  default = null
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "replication_role" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "administrator_login" {
  type    = string
  default = null
}

variable "administrator_password" {
  type    = string
  default = null
}

variable "authentication" {
  type = object({
    active_directory_auth_enabled = optional(bool, false)
    password_auth_enabled         = optional(bool, true)
    tenant_id                     = optional(string)
  })
  default = {}
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id                     = string
    primary_user_assigned_identity_id    = optional(string)
    geo_backup_key_vault_key_id          = optional(string)
    geo_backup_user_assigned_identity_id = optional(string)
  })
  default = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}

variable "maintenance_window" {
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  default = null
}

variable "high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  default = null
}
