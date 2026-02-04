variable "name" {
  type        = string
  description = "The name of the Azure Redis Cache."
}

variable "location" {
  type        = string
  description = "The Azure region where the Redis Cache will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group in which the Redis Cache will be created."
}

variable "capacity" {
  type        = string
  description = "The capacity of the Redis Cache."
}

variable "replicas_per_master" {
  description = "The number of replicas per master (only for Premium SKU)."
  type        = number
  default     = null
}

variable "shard_count" {
  description = "The number of shards for Redis Cluster (only for Premium SKU)."
  type        = number
  default     = null
}

variable "subnet_id" {
  description = "The subnet ID where the Redis Cache will be deployed (only for Premium SKU)."
  type        = string
  default     = null
}

variable "zones" {
  description = "The availability zones for Redis deployment."
  type        = list(string)
  default     = []
}

variable "sku" {
  type        = string
  description = "The SKU name of the Redis Cache."
}

variable "enable_non_ssl_port" {
  type        = bool
  description = "Enable or disable non-SSL port for the Redis Cache."
  default     = false
}

variable "minimum_tls_version" {
  type        = string
  description = "The minimum TLS version allowed for the Redis Cache."
  default     = "1.0"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable or disable public network access for the Redis Cache."
  default     = false

}

variable "identity_type" {
  type        = string
  description = "The type of identity to use for the Redis Cache."

}

variable "access_keys_authentication_enabled" {
  type        = bool
  description = "Enable or disable access keys authentication for the Redis Cache."
  default     = true

}

variable "identity_ids" {
  description = "A list of user-assigned identity IDs to be associated with the storage account."
  type        = list(string)
  default     = null
}

variable "enable_aof_backup" {
  description = "Enable AOF (Append-Only File) backup."
  type        = bool
  default     = false

}

variable "aunthentication_enabled" {
  description = "Enable data persistence (only applicable for Premium SKU)."
  type        = bool
  default     = true

}


variable "enable_data_persistence" {
  description = "Enable data persistence (only applicable for Premium SKU)."
  type        = bool
  default     = false
}

variable "data_persistence_backup_frequency" {
  description = "The frequency of RDB backups if data persistence is enabled."
  type        = number
  default     = 15
}

variable "data_persistence_backup_max_snapshot_count" {
  description = "Maximum number of snapshots for data persistence."
  type        = number
  default     = 1
}

variable "primary_blob_connection_string" {
  description = "The connection string for the primary blob storage account."
  type        = string
  default     = null
  
}

variable "redis_configuration" {
  description = "Additional Redis configuration settings."
  type        = map(any)
  default = {
    authentication_enabled          = true
    maxfragmentationmemory_reserved = 50
    maxmemory_delta                 = 50
    maxmemory_policy                = "allkeys-lru"
    maxmemory_reserved              = 50
    notify_keyspace_events          = "KEA"
  }
}


variable "patch_schedule" {
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  description = "The window for redis maintenance. The Patch Window lasts for 5 hours from the `start_hour_utc` "
  default     = null
}

variable "redis_family" {
  type        = string
  description = "The family of the Redis Cache."
  default     = "C"

}

variable "redis_version" {
  type        = string
  description = "The Redis version to use."
  default     = "6"

}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the Redis Cache."
  default     = {}
}
