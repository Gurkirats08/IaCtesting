

variable "resource_group" {
  description = "Resource group for the VM and disks"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "disk_name" {
  description = "Name of the data disk"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the data disk in GB"
  type        = number
}


variable "storage_account_type" {
  description = "Storage account type (Standard_LRS, Premium_LRS, etc.)"
  type        = string
}

variable "disk_encryption_set_id" {
  description = "ID of the disk encryption set for the data disk"
  type        = string

}