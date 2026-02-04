###### Skip Provider Variables ######
variable "skip_provider_registration" {
  type        = bool
  description = "The skip provider registation flag."
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "The ID of the subscription to which provider skip is needed."
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the VM extension."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group of the VM extension."
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the virtual machine for the extension."
}

variable "publisher" {
  type        = string
  description = "The publisher of the VM extension."
}

variable "type" {
  type        = string
  description = "The type of the VM extension."
}

variable "type_handler_version" {
  type        = string
  description = "The type handler version of the VM extension."
}

variable "auto_upgrade_minor_version" {
  type        = bool
  description = "Auto upgrade minor version of the VM extension."
}

variable "automatic_upgrade_enabled" {
  type        = bool
  description = "Automatic upgrade enabled for the VM extension."
}

variable "settings" {
  type        = any
  description = "Settings for the VM extension."
  default     = null
}

variable "protected_settings" {
  type        = any
  description = "Protected settings for the VM extension."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for the VM extension."
  default     = {}
}

