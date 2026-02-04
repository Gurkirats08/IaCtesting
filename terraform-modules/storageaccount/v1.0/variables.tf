variable "name" {
  description = "The name of the storage account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which storage account present."
  type        = string
}

variable "location" {
  description = "The location of the storage account."
  type        = string
}

variable "account_kind" {
  description = "The kind of the storage account."
  type        = string
  default     = "StorageV2"
  validation {
    condition     = can(index(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind))
    error_message = "Invalid account kind. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage, and StorageV2."
  }
}

variable "account_tier" {
  description = "The tier of the storage account."
  type        = string
  validation {
    condition     = can(index(["Standard", "Premium"], var.account_tier))
    error_message = "Invalid account tier. Valid options are Standard and Premium."
  }
}

variable "account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
  validation {
    condition     = can(index(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type))
    error_message = "Invalid account replication type. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  }
}

variable "cross_tenant_replication_enabled" {
  description = "Specifies whether cross-tenant replication is enabled for the storage account."
  type        = bool
  default     = true
}

variable "access_tier" {
  description = "The access tier of the storage account."
  type        = string
  default     = "Hot"
  validation {
    condition     = can(index(["Hot", "Cool"], var.access_tier))
    error_message = "Invalid access tier. Valid options are Hot and Cool."
  }
}

# variable "enable_https_traffic_only" {
#   description = "Specifies whether HTTPS traffic only is enabled for the storage account."
#   type        = bool
#   default     = true
# }

variable "min_tls_version" {
  description = "The minimum TLS version required for the storage account."
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = can(index(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version))
    error_message = "Invalid minimum TLS version. Valid options are TLS1_0, TLS1_1, and TLS1_2."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "Specifies whether nested items can be made public in the storage account."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Specifies whether shared access key is enabled for the storage account."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the storage account."
  type        = bool
  default     = false
}

variable "allowed_copy_scope" {
  description = "Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are AAD and PrivateLink."
  type        = string
  validation {
    condition     = var.allowed_copy_scope == null ? true : can(index(["AAD", "PrivateLink"], var.allowed_copy_scope))
    error_message = "Invalid allowed copy scope. Valid options are AAD and PrivateLink."
  }
  default = null
}

variable "sftp_enabled" {
  description = "Specifies whether SFTP is enabled for the storage account."
  type        = bool
  default     = false
}

variable "custom_domain_name" {
  description = "The custom domain name for the storage account."
  type        = string
  default     = null
}

variable "use_sub_domain_name" {
  description = "Specifies whether to use a subdomain for the custom domain of the storage account."
  type        = bool
  default     = false
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account."
  type        = bool
  default     = false
}

// variable "is_hns_enabled" {
//   description = "Specifies whether Hierarchical Namespace (HNS) is enabled for the storage account."
//   type        = bool
//   default     = false
// }

variable "key_vault_key_id" {
  description = "The ID of the key vault key used to encrypt the storage account."
  type        = string
  default = null
}

variable "user_assigned_identity_id" {
  description = "The ID of the user-assigned identity used to encrypt the storage account."
  type        = string
  default = null
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account"
  type        = string
  validation {
    condition     = var.identity_type == null ? true : can(index(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type))
    error_message = "Invalid identity_type. Please choose one of the following options: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
  default = null
}

variable "identity_ids" {
  description = "A list of user-assigned identity IDs to be associated with the storage account."
  type        = list(string)
  default = null
}

variable "delete_retention_days" {
  description = "The number of days to retain deleted files in the storage account."
  type        = number
  default     = 1

  validation {
    condition     = var.delete_retention_days >= 1 && var.delete_retention_days <= 365
    error_message = "delete_retention_days must be between 1 and 365 days."
  }
}

variable "versioning_enabled" {
  description = "Specifies whether versioning is enabled for the storage account."
  type        = bool
  default     = false
}

variable "change_feed_enabled" {
  description = "Specifies whether change feed is enabled for the storage account."
  type        = bool
  default     = false
}

variable "change_feed_retention_in_days" {
  description = "The number of days to retain the change feed in the storage account."
  type        = number
  default     = 1

  validation {
    condition     = var.change_feed_retention_in_days >= 1 && var.change_feed_retention_in_days <= 146000
    error_message = "change_feed_retention_in_days must be between 1 and 146000 days."
  }
}

variable "allowed_headers" {
  description = "The allowed headers for CORS in the storage account."
  type        = list(string)
  default     = []
}

variable "allowed_methods" {
  description = "The allowed methods for CORS in the storage account."
  type        = list(string)
  validation {
    condition     = var.allowed_methods == null ? true : can(contains(["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"], var.allowed_methods))
    error_message = "Invalid allowed methods. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT, and PATCH."
  }
  default = null
}

variable "allowed_origins" {
  description = "A list of origin domains that will be allowed by CORS."
  type        = list(string)
  default     = []
}

variable "exposed_headers" {
  description = "The exposed headers for CORS in the storage account."
  type        = list(string)
  default     = []
}

variable "max_age_in_seconds" {
  description = "The maximum age in seconds for CORS in the storage account."
  type        = number
  default = null
}

variable "restore_policy_days" {
  description = "The number of days to retain restore points in the storage account."
  type        = number
  default = null
  validation {
    condition     = var.restore_policy_days == null ?  true : var.restore_policy_days >= 1 && var.restore_policy_days <= 30
    error_message = "restore_policy_days must be between 1 and 30 days."
  }
}

variable "delete" {
  description = "Indicates whether all delete requests should be logged."
  type        = bool
  default     = true
}

variable "read" {
  description = "Indicates whether all read requests should be logged."
  type        = bool
  default     = true
}

variable "storage_analytics_version" {
  description = "The version of storage analytics to configure."
  type        = string
  default = null
}

variable "write" {
  description = "Indicates whether all write requests should be logged."
  type        = bool
  default     = true
}

variable "retention_policy_days" {
  description = "The number of days to retain data in the storage account."
  type        = number
  default     = 1
}

variable "minute_metrics_enabled" {
  description = "Specifies whether minute metrics are enabled for the Queue service."
  type        = bool
  default     = true
}

variable "minute_metrics_include_apis" {
  description = "Indicates whether metrics should generate summary statistics for called API operations."
  type        = bool
  default     = false
}

variable "hour_metrics_enabled" {
  description = "Specifies whether hour metrics are enabled for the storage account."
  type        = bool
  default     = true
}

variable "hour_metrics_include_apis" {
  description = "Indicates whether metrics should generate summary statistics for called API operations."
  type        = bool
  default = null
}

variable "index_document" {
  description = "The index document for the static website of the storage account."
  type        = string
  default     = "index.html"
}

variable "error_404_document" {
  description = "The error 404 document for the static website of the storage account."
  type        = string
  default = null
}

variable "retention_days" {
  description = "Specifies the number of days that the storage share should be retained, between 1 and 365 days."
  type        = number
  default     = 7

  validation {
    condition     = var.retention_days >= 1 && var.retention_days <= 365
    error_message = "retention_days must be between 1 and 365 days."
  }
}

variable "smb_versions" {
  description = "A set of SMB protocol versions."
  type        = set(string)

  validation {
    condition     = var.smb_versions == null ?  true : can(contains(["SMB2.1", "SMB3.0", "SMB3.1.1"], var.smb_versions))
    error_message = "Invalid SMB version. Valid options are SMB2.1, SMB3.0 and SMB3.1.1."
  }
  default = null
}

variable "authentication_types" {
  description = "A set of SMB authentication methods."
  type        = set(string)
  default = null
  validation {
    condition     = var.authentication_types == null ? true : can(contains(["NTLMv2", "Kerberos"], var.authentication_types))
    error_message = "Invalid authentication type. Valid options are NTLMv2 and Kerberos."
  }
}

variable "multichannel_enabled" {
  description = "Indicates whether multichannel is enabled."
  type        = bool
  default     = false
}

variable "local_user_enabled" {
  description = "Specifies whether local user is enabled for the storage account."
  type        = bool
  default     = true
}

variable "queue_encryption_key_type" {
  description = "The encryption key type for the storage account queue."
  type        = string
  default     = "Service"
  validation {
    condition     = can(index(["Account", "Service"], var.queue_encryption_key_type))
    error_message = "Invalid queue encryption key type. Valid options are Account and Service."
  }
}

variable "table_encryption_key_type" {
  description = "The encryption key type for the storage account table."
  type        = string
  default     = "Service"

  validation {
    condition     = can(index(["Account", "Service"], var.table_encryption_key_type))
    error_message = "Invalid table encryption key type. Valid options are Account and Service."
  }
}

variable "infrastructure_encryption_enabled" {
  description = "Specifies whether infrastructure encryption is enabled for the storage account."
  type        = bool
  default     = true
}

variable "allow_protected_append_writes" {
  description = "Specifies whether protected append writes are allowed for the storage account."
  type        = bool
  default = false
}

variable "state" {
  description = "The state of the storage account."
  type        = string
  default = null
  validation {
    condition     = var.state == null ? true : can(index(["Unlocked", "Locked", "Disabled"], var.state))
    error_message = "Invalid state. Valid options are Unlocked, Locked and Disabled."
  }
}

variable "period_since_creation_in_days" {
  description = "The period since creation in days for the storage account."
  type        = number
  default = null
}

variable "expiration_period" {
  description = "The SAS expiration period in format of DD.HH:MM:SS."
  type        = string
  default = null
  validation {
    condition     = var.expiration_period == null ? true : can(regex("^\\d{2}\\.\\d{2}:\\d{2}:\\d{2}$", var.expiration_period))
    error_message = "Expiration period must be in the format DD.HH:MM:SS."
  }
}

variable "expiration_action" {
  description = "The SAS expiration action. The only possible value is Log at this moment."
  type        = string
  default     = "Log"
  validation {
    condition     = contains(["Log"], var.expiration_action)
    error_message = "Invalid expiration action. Valid options are Log."
  }
}

variable "tags" {
  description = "The tags for the storage account."
  type        = map(string)
  default     = null
}

variable "directory_type" {
  description = "The directory type of the storage account."
  type        = string
  validation {
    condition     = var.directory_type == null ? true : can(index(["AADDS", "AD", "AADKERB"], var.directory_type))
    error_message = "Invalid directory type. Valid options are AADDS, AD, and AADKERB."
  }
  default = null
}

variable "azure_files_domain_name" {
  description = "The domain name for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "azure_files_domain_guid" {
  description = "The domain GUID for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "azure_files_domain_sid" {
  description = "The domain SID for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "domain_sid" {
  description = "The domain SID for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "storage_sid" {
  description = "The storage SID for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "forest_name" {
  description = "The forest name for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "netbios_domain_name" {
  description = "The NetBIOS domain name for Azure Files authentication in the storage account."
  type        = string
  default = null
}

variable "routing_choice" {
  description = "The routing choice for the storage account."
  type        = string
  default = null
}

variable "publish_microsoft_endpoints" {
  description = "Specifies whether to publish Microsoft endpoints for the storage account."
  type        = bool
  default = null
}

variable "publish_internet_endpoints" {
  description = "Specifies whether to publish Internet endpoints for the storage account."
  type        = bool
  default = null
}

variable "share_properties_enabled" {
  description = "Flag to enable or disable share_properties block"
  type        = bool
  default     = false
}

variable "smb_enabled" {
  description = "Flag to enable or disable smb block"
  type        = bool
  default     = false
}

variable "retention_policy_enabled" {
  description = "Flag to enable or disable retention_policy block"
  type        = bool
  default     = false
}

variable "blob_properties_enabled" {
  description = "Flag to enable or disable blob_properties block"
  type        = bool
  default     = false
}

variable "delete_retention_policy_enabled" {
  description = "Flag to enable or disable delete_retention_policy block"
  type        = bool
  default     = false
}

variable "restore_policy_enabled" {
  description = "Flag to enable or disable restore_policy block"
  type        = bool
  default     = false
}

variable "queue_properties_enabled" {
  description = "Flag to enable or disable queue_properties block"
  type        = bool
  default     = false
}

variable "static_website_enabled" {
  description = "Flag to enable or disable static_website block"
  type        = bool
  default     = false
}

variable "azure_files_authentication_enabled" {
  description = "Flag to enable or disable azure_files_authentication block"
  type        = bool
  default     = false
}

variable "routing_enabled" {
  description = "Flag to enable or disable routing block"
  type        = bool
  default     = false
}

variable "retention_days_enaled" {
  description = "Flag to enable or disable retention_days block"
  type        = bool
  default     = false
}

variable "logging_enabled" {
  description = "Flag to enable or disable logging block"
  type        = bool
  default     = false
}