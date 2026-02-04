variable "name"{
    type = string
    description = "Search Service Name"
}

variable "location" {
  type        = string
  description = "Location for all resources when creating a new resource group."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the new resource group to be created."
  # You can provide a default value if needed
  # default     = "my-new-resource-group"
}

variable "sku" {
  type        = string
  description = "The sku name of the Azure Search service."
  default     = "basic"
}

variable "replica_count" {
  type        = number
  description = "The number of replicas in the service."
  default     = 1
}

variable "partition_count" {
  type        = number
  description = "The number of partitions in the service."
  default     = 1
}
