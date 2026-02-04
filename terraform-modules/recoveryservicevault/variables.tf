variable "recovery_services_vault_name" {
  description = "Name of the recovery services vault."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "sku" {
  description = "Sets the vault's SKU."
  type        = string
  validation {
    condition     = contains(["Standard", "RS0"], var.sku)
    error_message = "Invalid SKU type. Possible values are 'Standard' or 'RS0'."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Is it enabled to access the vault from public networks."
  type        = bool
  default     = true
}

variable "immutability" {
  description = "Immutability settings of the vault."
  type        = string
  default     = "Unlocked"
  validation {
    condition     = contains(["Locked", "Unlocked", "Disabled"], var.immutability)
    error_message = "Invalid immutability setting. Possible values are 'Locked', 'Unlocked', or 'Disabled'."
  }
}

variable "storage_mode_type" {
  description = "The storage type of the Recovery Services Vault."
  type        = string
  default     = "GeoRedundant"
  validation {
    condition     = contains(["GeoRedundant", "LocallyRedundant", "ZoneRedundant"], var.storage_mode_type)
    error_message = "Invalid storage mode type. Possible values are 'GeoRedundant', 'LocallyRedundant', or 'ZoneRedundant'."
  }
}

variable "cross_region_restore_enabled" {
  description = "Is cross region restore enabled for this Vault?"
  type        = bool
  default     = false
}

variable "soft_delete_enabled" {
  description = "Is soft delete enable for this Vault?"
  type        = bool
  default     = true
}

variable "classic_vmware_replication_enabled" {
  description = "Whether to enable the Classic experience for VMware replication."
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity for the Recovery Services Vault."
  type        = string
  default = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Invalid identity type. Allowed values are 'SystemAssigned', 'UserAssigned', or 'SystemAssigned, UserAssigned'."
  }
}

variable "identity_ids" {
  description = "A list of User Assigned Managed Identity IDs to be assigned to the Recovery Services Vault."
  type        = list(string)
  default = null
}

# variable "encryption_key_id" {
#   description = "The Key Vault key id used to encrypt this vault. Key managed by Vault Managed Hardware Security Module is also supported."
#   type        = string
#   default = null
# }

# variable "infrastructure_encryption_enabled" {
#   description = "Enabling/Disabling the Double Encryption state."
#   type        = bool
#   default = true
# }

# variable "user_assigned_identity_id" {
#   description = "Specifies the user assigned identity ID to be used."
#   type        = string
#   default = null
# }

# variable "use_system_assigned_identity" {
#   description = "Indicate whether system assigned identity should be used or not."
#   type        = bool
#   default = true
# }

variable "alerts_for_all_job_failures_enabled" {
  description = "Enabling/Disabling built-in Azure Monitor alerts for security scenarios and job failure scenarios."
  type        = bool
  default     = true
}

variable "alerts_for_critical_operation_failures_enabled" {
  description = "Enabling/Disabling alerts from the older (classic alerts) solution."
  type        = bool
  default     = true
}


