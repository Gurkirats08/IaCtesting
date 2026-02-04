variable "server_name" {
  description = "The name of the MySQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the MySQL server will be deployed."
  type        = string
}

variable "version" {
  description = "The version of MySQL to use. Possible values are 5.7, and 8.0.21."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login name for the MySQL server."
  type        = string
}

variable "administrator_password" {
  description = "The password associated with the administrator login."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU name for the MySQL server."
  type        = string
}

variable "create_mode" {
  description = "The creation mode. Possible values: Default, PointInTimeRestore, GeoRestore, Replica."
  type        = string
  default     = "Default"
}

variable "source_server_id" {
  description = "The resource ID of the source server for restore or replica."
  type        = string
  default     = null
}

variable "point_in_time_restore_time_in_utc" {
  description = "The point in time to restore from when create_mode is PointInTimeRestore."
  type        = string
  default     = null
}

variable "replication_role" {
  description = "The replication role. Possible value is None."
  type        = string
  default     = "None"
}

variable "delegated_subnet_id" {
  description = "The ID of the subnet to deploy the server into."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to use with this server."
  type        = string
  default     = null
}

variable "public_network_access" {
  description = "Whether public network access is allowed. Possible values: Enabled, Disabled."
  type        = string
  default     = "Disabled"
}

variable "zone" {
  description = "Availability Zone for the server. Possible values: 1, 2, 3."
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Number of days to retain backups."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Whether geo-redundant backup is enabled."
  type        = bool
  default     = false
}

# Storage block
variable "storage_auto_grow_enabled" {
  description = "Whether storage auto-grow is enabled."
  type        = bool
  default     = true
}

variable "storage_io_scaling_enabled" {
  description = "Whether IO scaling is enabled."
  type        = bool
  default     = false
}

variable "storage_iops" {
  description = "The IOPS for the MySQL Flexible Server."
  type        = number
  default     = 360
}

variable "storage_size_gb" {
  description = "The maximum storage size in GB."
  type        = number
  default     = 20
}

# High availability block
variable "ha_mode" {
  description = "High availability mode. Possible values: SameZone, ZoneRedundant."
  type        = string
  default     = null
}

variable "ha_standby_availability_zone" {
  description = "The availability zone of the standby server."
  type        = string
  default     = null
}

# Maintenance window block
variable "maintenance_day_of_week" {
  description = "Day of week for maintenance window (0=Sunday)."
  type        = number
  default     = 0
}

variable "maintenance_start_hour" {
  description = "Start hour for maintenance window."
  type        = number
  default     = 0
}

variable "maintenance_start_minute" {
  description = "Start minute for maintenance window."
  type        = number
  default     = 0
}

# Identity block
variable "identity_type" {
  description = "Type of managed identity to use. Only value: UserAssigned."
  type        = string
  default     = "UserAssigned"
}

variable "identity_ids" {
  description = "List of user-assigned identity IDs."
  type        = list(string)
  default     = []
}

# Customer managed key block
variable "key_vault_key_id" {
  description = "The ID of the key vault key to use for encryption."
  type        = string
  default     = null
}

variable "primary_user_assigned_identity_id" {
  description = "The primary identity used for customer-managed key."
  type        = string
  default     = null
}

variable "geo_backup_key_vault_key_id" {
  description = "The key vault key ID for geo backups."
  type        = string
  default     = null
}

variable "geo_backup_user_assigned_identity_id" {
  description = "The user-assigned identity ID for geo backups."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to the MySQL server."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Enable public network access for the MySQL server."
  type        = bool
  default     = false

}
