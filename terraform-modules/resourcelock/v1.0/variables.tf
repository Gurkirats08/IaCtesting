variable "name" {
  description = "Name of the lock"
  type        = string
  
}

variable "lock_level" {
  description = "The lock level - CanNotDelete or ReadOnly"
  type        = string
  
}

variable "notes" {
  description = "Notes for the lock"
  type        = string
  
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
}

variable "resource_type" {
  description = "Type of the resource"
  type        = string
  default     = null
}

variable "resource_name" {
  description = "Name of the resource"
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}