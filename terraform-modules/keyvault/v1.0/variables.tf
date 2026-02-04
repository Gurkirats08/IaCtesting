variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "key_vault_location" {
  description = "The location of the keyvault"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the key vault"
  type        = string
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain soft-deleted keys"
  type        = number
  default     = 30
}

variable "enabled_for_deployment" {
  description = "Whether the key vault is enabled for deployment"
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Whether the key vault is enabled for disk encryption"
  type        = bool
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "Whether the key vault is enabled for template deployment"
  type        = bool
  default     = true
}

variable "enabled_for_rbac_authorization" {
  description = "Whether the key vault is enabled for RBAC authorization"
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the key vault"
  type        = bool
  default     = true
}

variable "sku_name" {
  description = "The SKU of the key vault"
  type        = string
  validation {
    condition     = var.sku_name == "premium" || var.sku_name == "standard"
    error_message = "SKU must be either 'premium' or 'standard'."
  }

}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the key vault"
  type        = bool
  default     = true
}

variable "tenant_id" {
  description = "The tenant ID to use for the key vault"
  type        = string
}

variable "access_policy" {
  type = list(object({
    tenant_id = string
    object_id = string
    application_id = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions = optional(list(string))
    secret_permissions = optional(list(string))
    storage_permissions = optional(list(string))
  }))
  description = "Access Policy for keyvault"
  default = []
}

variable "network_acls" {
  type = object({
    default_action = string
    bypass = string
    ip_rules = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  description = "Network ACL's for keyvault"
  default = null
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostic logs to"
  type        = string
}