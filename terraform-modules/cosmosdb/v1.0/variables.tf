variable "name" {
  description = "Name of the Cosmos DB account"
  type        = string

}

variable "location" {
  description = "Location of the Cosmos DB account"
  type        = string

}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

}

variable "offer_type" {
  description = "Offer type of the Cosmos DB account"
  type        = string

}

variable "kind" {
  description = "Kind of the Cosmos DB account"
  type        = string

}

variable "default_identity_type" {
  description = "Default identity type for the Cosmos DB account"
  type        = string
  default     = "FirstPartyIdentity"

}

variable "minimal_tls_version" {
  description = "Minimal TLS version for the Cosmos DB account"
  type        = string
  default     = "Tls12"

}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for the Cosmos DB account"
  type        = bool

}

variable "capability1" {
  description = "Capability 1 for the Cosmos DB account"
  type        = string

}

variable "capability2" {
  description = "Capability 2 for the Cosmos DB account"
  type        = string

}

variable "consistency_level" {
  description = "Consistency level for the Cosmos DB account"
  type        = string

}

variable "max_staleness_prefix" {
  description = "Max staleness prefix for the Cosmos DB account"
  type        = number

}

variable "max_interval_in_seconds" {
  description = "Max interval in seconds for the Cosmos DB account"
  type        = number

}

variable "geo_location1" {
  description = "First geo location for the Cosmos DB account"
  type        = string

}

variable "failover_priority1" {
  description = "Failover priority for the first geo location"
  type        = number

}

#Optional variables------------------------------------------------

variable "schema_type" {
  description = "Schema type for the analytical storage"
  type        = string
  default     = "FullFidelity"

}

variable "analytical_storage_enabled" {
  description = "Enable analytical storage for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "total_throughput_limit" {
  description = "Total throughput limit for the Cosmos DB account"
  type        = number
  default     = -1

}

variable "backup_type" {
  description = "Backup type for the Cosmos DB account"
  type        = string
  default     = "Periodic"

}

variable "create_mode" {
  description = "Create mode for the Cosmos DB account"
  type        = string

}

variable "ip_range_filter" {
  description = "IP range filter for the Cosmos DB account"
  type        = list(string)
  default     = []

}

variable "free_tier_enabled" {
  description = "Enable free tier for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "backup_tier" {
  description = "Backup tier for the Cosmos DB account"
  type        = string
  default     = "Continuous30Days"

}

variable "max_interval_in_minutes" {
  description = "Max interval in minutes for the backup"
  type        = number
  default     = 240

}

variable "retention_in_hours" {
  description = "Retention period in hours for the backup"
  type        = number
  default     = 8

}

variable "storage_redundancy" {
  description = "Storage redundancy for the backup"
  type        = string
  default     = "Geo"

}

variable "partition_merge_enabled" {
  description = "Enable partition merge for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "burst_capacity_enabled" {
  description = "Enable burst capacity for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "public_network_access_enabled" {
  description = "Enable public network access for the Cosmos DB account"
  type        = bool
  default     = true

}

variable "is_virtual_network_filter_enabled" {
  description = "Enable virtual network filter for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "managed_hsm_key_id" {
  description = "Managed HSM key ID for the Cosmos DB account"
  type        = string

}

variable "multiple_write_locations_enabled" {
  description = "value for multiple write locations enabled"
  type        = bool
  default     = false

}

variable "access_key_metadata_writes_enabled" {
  description = "value for access key metadata writes enabled"
  type        = bool
  default     = true

}

variable "identity_type" {
  description = "Identity type for the Cosmos DB account"
  type        = string
  default     = "SystemAssigned"

}

variable "identity_ids" {
  description = "Identity IDs for the Cosmos DB account"
  type        = list(string)
  default     = []

}

variable "mongo_server_version" {
  description = "Mongo server version for the Cosmos DB account"
  type        = string
  default     = "4.2"

}

variable "network_acl_bypass_for_azure_services" {
  description = "Enable network ACL bypass for Azure services"
  type        = bool
  default     = false

}

variable "network_acl_bypass_ids" {
  description = "Network ACL bypass IDs for the Cosmos DB account"
  type        = list(string)
  default     = []

}

variable "local_authentication_disabled" {
  description = "Disable local authentication for the Cosmos DB account"
  type        = bool
  default     = false

}

variable "allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = []

}

variable "max_age_in_seconds" {
  description = "Max age in seconds for CORS"
  type        = number
  default     = 1

}

variable "allowed_methods" {
  description = "Allowed methods for CORS"
  type        = list(string)
  default     = []

}

variable "allowed_headers" {
  description = "Allowed headers for CORS"
  type        = list(string)
  default     = []

}

variable "exposed_headers" {
  description = "Exposed headers for CORS"
  type        = list(string)
  default     = []

}

variable "source_cosmosdb_account_id" {
  description = "Source Cosmos DB account ID for restore"
  type        = string

}

variable "restore_timestamp_in_utc" {
  description = "Restore timestamp in UTC for the Cosmos DB account"
  type        = string

}






