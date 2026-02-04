# Required Variables

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "acr_rg" {
  description = "Name of the resource group where the ACR will be deployed"
  type        = string
}

variable "acr_location" {
  description = "Azure region where the ACR will be deployed"
  type        = string
}

variable "sku" {
  description = "SKU tier of ACR (Basic, Standard, Premium)"
  type        = string
}

# ===========================
# Optional Variables

variable "admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = false
}

variable "network_rule_bypass_option" {
  description = "Bypass rules for network access (e.g., AzureServices, None)"
  type        = string
  default     = "AzureServices"
}

variable "trust_policy_enabled" {
  description = "Enable content trust policy for the registry"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access to ACR"
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy for the registry (Premium SKU required)"
  type        = bool
  default     = true
}

variable "retention_policy_in_days" {
  description = "Number of days to retain untagged manifests"
  type        = number
  default     = 7
}

variable "export_policy_enabled" {
  description = "Allow artifacts to be exported from the registry"
  type        = bool
  default     = true
}

variable "data_endpoint_enabled" {
  description = "Enable data endpoint for network integration"
  type        = bool
  default     = false
}

variable "anonymous_pull_enabled" {
  description = "Allow anonymous pull access to the registry"
  type        = bool
  default     = false 
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy for the registry"
  type        = bool
  default     = false
  
}

variable "identity" {
  description = "Type of managed identity (None, SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_id" {
  description = "User-assigned identity ID (Required if identity type is UserAssigned)"
  type        = string
  default     = null
}


variable "virtual_network_rules" {
  description = "List of Virtual Network rules for access control"
  type        = list(map(string))
  default     = []
}


variable "tags" {
  description = "Tags to assign to the ACR resource"
  type        = map(string)
  default     = {}
}

# variable "georeplication_locations" {
#   description = "List of locations for geo-replication (Premium SKU only)"
#   type        = list(string)
#   default     = []
  
# }

