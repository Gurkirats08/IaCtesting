variable "name" {
  description = "The name of the Automation Account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the Automation Account will be created"
  type        = string
}

variable "sku" {
  description = "The SKU of the Automation Account (e.g., 'Basic')"
  type        = string
}

variable "local_authentication_enabled" {
  description = "Whether local authentication is enabled"
  type        = bool
  
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  type        = bool
  
}

variable "identity_type" {
  description = "The type of Managed Identity for the Automation Account"
  type        = string
}

variable "identity_ids" {
  description = "Optional list of identity IDs to associate with the Automation Account"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to associate with the Automation Account"
  type        = map(string)
  default     = {}
}
