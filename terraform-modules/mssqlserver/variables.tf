variable "resource_group_id" {
  type        = string
  description = "The ID of Resources Group"
}

variable "mssql_server_name" {
  type        = string
  description = "The name of MSSQL Server"
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags of the MS SQL Server."
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "ID of the existing Key vault to store the Customer Managed Key for Encryption."
}

variable "key_vault_key_id" {
  type        = string
  description = "Key ID of the Customer Managed Key to be used for Encryption."
}

variable "login_username" {
  type        = string
  description = "(Required) The login username of the Azure AD Administrator of this SQL Server."
}

variable "object_id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "storage_account_id" {
  type        = string
  description = "Storage Account Resource ID for storing audit logs"
}

variable "blob_endpoint" {
  type        = string
  description = "Storage Account blob endpoint for storing audit logs"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "User Assigned Identity Resource ID to assign to SQL Server"
}

variable "user_assigned_identity_principal_id" {
  type        = string
  description = "User Assigned Identity Principal ID to assign to SQL Server"
}
