variable "name" {
  type        = string
  description = "The name of the Azure Machine Learning workspace."
}

variable "workspace_display_name" {
  type        = string
  description = "A user-friendly display name for the Azure Machine Learning workspace."
}

variable "location" {
  type        = string
  description = "The Azure region where the Azure Machine Learning workspace will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group in which the Azure Machine Learning workspace will be created."
}

variable "application_insights_id" {
  type        = string
  description = "The Application Insights resource ID to associate with the Azure Machine Learning workspace."
}

variable "key_vault_id" {
  type        = string
  description = "The Key Vault resource ID to associate with the Azure Machine Learning workspace."
}

variable "storage_account_id" {
  type        = string
  description = "The Storage Account resource ID to associate with the Azure Machine Learning workspace."
}
