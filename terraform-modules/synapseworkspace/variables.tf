variable "synapse_workspace_name" {
  type        = string
  description = "The name of the Azure Synapse Analytics workspace."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group in which the Synapse Analytics workspace will be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the Synapse Analytics workspace will be created."
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the Azure Storage account associated with the Synapse Analytics workspace."
}

variable "aad_login" {
  type        = string
  description = "The name or email address of the Azure AD admin for the Synapse Analytics workspace."
}

variable "aad_object_id" {
  type        = string
  description = "The object ID of the Azure AD admin. This is a unique identifier in Azure AD."
}

variable "aad_tenant_id" {
  type        = string
  description = "The ID of the Azure AD tenant associated with the Azure Synapse Analytics workspace admin."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to associate with the Azure Synapse Analytics workspace."
  default     = {}
}
