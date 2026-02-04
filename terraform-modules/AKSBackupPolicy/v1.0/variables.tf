
variable "backupvaultname" {
  description = "Name of the backup vault"
  type        = string
}

variable "backup_policy_name" {
  description = "Name of the backup policy"
  type        = string

}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

}

variable "cluster_access_name" {
  description = "Name of the cluster access"
  type        = string

}

variable "stg_container_name" {
  description = "Name of the storage container"
  type        = string

}

variable "backup_extension_name" {
  description = "Name of the backup extension"
  type        = string

}



variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string

}

variable "storage_account_rg" {
  description = "Name of the storage account resource group"
  type        = string

}

variable "subscriptionId" {
  description = "Subscription ID"
  type        = string

}

variable "tenantId" {
  description = "Tenant ID"
  type        = string

}

variable "akscluster_name" {
  description = "Name of the AKS cluster"
  type        = string

}

variable "aks_cluster_rg" {
  description = "Name of the AKS cluster resource group"
  type        = string

}

variable "cluster_instance_name" {
  description = "Name of the cluster instance"
  type        = string

}

variable "location" {
  description = "Location of the resources"
  type        = string

}

variable "resource_group_id" {
  description = "Resource group ID"
  type        = string

}

variable "managed_identity_principal_id" {
  description = "Managed identity principal ID"
  type        = string

}