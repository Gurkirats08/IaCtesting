variable "disk_encryption_set_name" {
  description = "The name of the Disk Encryption Set."
  type        = string
}
 
variable "location" {
  description = "The location for the Disk Encryption Set."
  type        = string
}
 
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
 
variable "key_id" {
  description = "The ID of the key in the Key Vault."
  type        = string
}
 
variable "key_vault_id" {
  description = "The ID of the Key Vault."
  type        = string
}
 
variable "tenant_id" {
  description = "The tenant ID."
  type        = string
}
 
 variable "user_assigned_identity" {
  description = "The object ID."
  type        = list(string)
 }

 variable "auto_key_rotation_enabled" {
  description = "Enable auto key rotation."
  type        = bool
  default     = false
   
 }
 