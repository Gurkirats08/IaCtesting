# User Node Pool Variables
variable "user_node_pool_mode" {
  type        = string
  description = "Mode for the user node pool, e.g., 'User' or 'System'."
  default     = "User"
}

variable "user_node_pool_name" {
  type    = string
  default = "usernodepool"
}

variable "tags" {
  type        = map(string)
  description = "Environment type"
}

variable "user_node_pool_kubernetes_cluster_id" {
  type    = string
}

variable "user_node_pool_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "user_node_pool_availability_zones" {
  type    = list(string)
  default = null
}

variable "user_node_pool_enable_auto_scaling" {
  type    = bool
  default = true
}


variable "user_node_pool_enable_host_encryption" {
  type    = bool
  default = true
}

variable "user_node_pool_os_disk_type" {
  type    = string
  default = "Managed"
}

variable "user_node_pool_os_disk_size_gb" {
  type    = number
  default = 128
}

variable "user_node_pool_max_pods" {
  type    = number
  default = null
}

variable "user_node_pool_max_count" {
  type    = number
  default = 5
}

variable "user_node_pool_min_count" {
  type    = number
  default = 3
}

variable "user_node_pool_node_count" {
  type    = number
  default = 3
}

variable "user_node_pool_only_critical_addons_enabled" {
  type    = bool
  default = null
}

variable "user_node_pool_vnet_subnet_id" {
  type    = string
  default = null
}

variable "drain_timeout_in_minutes" {
  type    = string
  default = "0"  
}

variable "node_soak_duration_in_minutes" {
  type    = string
  default = "0"
  
}

variable "max_surge" {
  type    = string
  default = "10%"
  
}
