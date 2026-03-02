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

variable "family" {
  type        = string
  description = "The family of the Redis Cache."
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
