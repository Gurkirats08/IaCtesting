# General AKS Cluster Variables
variable "name" {
  type        = string
  description = "AKS Cluster Name"
}

variable "location" {
  type    = string
  default = "uaenorth"
}

variable "resource_group_name" {
  type = string
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID"
  default     = null
}

variable "dns_prefix" {
  type        = string
  description = "DNS Prefix"
  default     = null
}

variable "sku_tier" {
  type    = string
  default = "Standard"
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "service_address_range" {
  type    = string
  default = null
}

variable "dns_ip" {
  type    = string
  default = null
}

variable "automatic_channel_upgrade" {
  type    = string
  default = null
}

variable "node_resource_group" {
  type    = string
  default = null
}

variable "azure_policy_enabled" {
  type    = bool
  default = false
}

variable "assign_identity" {
  type    = bool
  default = null
}

variable "api_server_authorized_ip_ranges" {
  type    = set(string)
  default = null
}

variable "admin_username" {
  type        = string
  default     = null
  description = "Admin Username"
}

variable "network_plugin" {
  type    = string
  default = "azure"
}

variable "azure_rbac_enabled" {
  type    = bool
  default = false
}

variable "pod_cidr" {
  type    = string
  default = null
}

variable "outbound_type" {
  type    = string
  default = "loadBalancer"
}

variable "network_policy" {
  type    = string
  default = null
}

variable "admin_group_object_ids" {
  type    = list(string)
  default = null
}

variable "tenant_id" {
  type = string

}

variable "oidc_issuer_enabled" {
  type    = bool
  default = true
}

variable "workload_identity_enabled" {
  type    = bool
  default = true
}

variable "network_plugin_mode" {
  type    = string
  default = null
}

# Default Node Pool Variables
variable "default_node_pool_name" {
  type        = string
  description = "Default Node Pool Name"
}

variable "default_node_pool_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "default_node_pool_availability_zones" {
  type    = list(number)
  default = null
}

variable "default_node_pool_enable_auto_scaling" {
  type    = bool
  default = true
}


variable "default_node_pool_enable_host_encryption" {
  type    = bool
  default = true
}

variable "default_node_pool_os_disk_type" {
  type    = string
  default = "Managed"
}

variable "default_node_pool_os_disk_size_gb" {
  type    = number
  default = null
}

variable "default_node_pool_max_pods" {
  type    = number
  default = null
}

variable "default_node_pool_max_count" {
  type    = number
  default = null
}

variable "default_node_pool_min_count" {
  type    = number
  default = null
}

variable "default_node_pool_node_count" {
  type    = number
  default = null
}

variable "default_node_pool_only_critical_addons_enabled" {
  type    = bool
  default = null
}

variable "default_node_pool_vnet_subnet_id" {
  type        = string
  description = "Default Node Pool VNet Subnet ID"
  default     = null
}

# Identity Configuration
variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "identity_ids" {
  type    = list(string)
  default = null
}

# Outbound and Scaling Configurations
variable "outbound_ports_allocated" {
  type    = number
  default = 0
}

variable "idle_timeout_in_minutes" {
  type    = number
  default = 4
}

variable "managed_outbound_ip_count" {
  type    = number
  default = 1
}

# Scaling & Auto-scaling Configuration
variable "balance_similar_node_groups" {
  type    = bool
  default = false
}

variable "max_graceful_termination_sec" {
  type    = string
  default = "600"
}

variable "scale_down_delay_after_add" {
  type    = string
  default = null
}

variable "scale_down_delay_after_delete" {
  type    = string
  default = null
}

variable "scale_down_delay_after_failure" {
  type    = string
  default = "3m"
}

variable "scan_interval" {
  type    = string
  default = null
}

variable "scale_down_unneeded" {
  type    = string
  default = null
}

variable "scale_down_unready" {
  type    = string
  default = null
}

variable "scale_down_utilization_threshold" {
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

#-------------------------------------------
#Optional Variables for AKS Cluster

variable "log_analytics_workspace_id" {
  type    = string
  default = null
  
}

variable "cost_analysis_enabled" {
  description = "Enable cost analysis for the AKS cluster"
  type        = bool
  default     = false
}

variable "disk_encryption_set_id" {
  description = "Disk encryption set ID for the cluster"
  type        = string
  default     = null
}

variable "edge_zone" {
  description = "Edge zone for the AKS cluster"
  type        = string
  default     = null
}

variable "http_application_routing_enabled" {
  description = "Enable HTTP application routing"
  type        = bool
  default     = false
}

variable "http_proxy" {
  description = "HTTP Proxy URL"
  type        = string
  default     = ""
}

variable "https_proxy" {
  description = "HTTPS Proxy URL"
  type        = string
  default     = ""
}

variable "no_proxy" {
  description = "No Proxy settings"
  type        = list(string)
  default     = []
}

variable "image_cleaner_enabled" {
  description = "Enable image cleaner"
  type        = bool
  default     = false
}

variable "image_cleaner_interval_hours" {
  description = "Image cleaner interval in hours"
  type        = number
  default     = 24
}


# variable "ingress_application_gateway_subnet_id" {
#   description = "Subnet ID for the Ingress Application Gateway"
#   type        = string
#   default     = null
# }

# variable "ingress_application_gateway_id" {
#   description = "ID of the Ingress Application Gateway"
#   type        = string
#   default     = null
  
# }

# variable "ingress_application_gateway_name" {
#   description = "Name of the Ingress Application Gateway"
#   type        = string
#   default     = "defualt"
  
# }

# variable "ingress_application_gateway_subnet_cidr" {
#   description = "CIDR for the Ingress Application Gateway subnet"
#   type        = string
#   default     = null
# }


variable "kubelet_identity_client_id" {
  description = "Kubelet identity client ID"
  type        = string
  default     = null
}

variable "kubelet_identity_object_id" {
  description = "Kubelet identity object ID"
  type        = string
  default     = null
}

variable "kubelet_identity_user_assigned_identity_id" {
  description = "User assigned identity ID for kubelet"
  type        = string
  default     = null
}

variable "local_account_disabled" {
  description = "Disable local accounts"
  type        = bool
  default     = false
}

variable "maintenance_window_day" {
  description = "Day of maintenance window"
  type        = string
  default     = "Sunday"
}

variable "maintenance_window_hours" {
  description = "Maintenance window allowed hours"
  type        = list(number)
  default     = [2, 3, 4]
}

variable "maintenance_window_auto_upgrade_frequency" {
  description = "Auto upgrade frequency"
  type        = string
  default     = "Weekly"
}

variable "maintenance_window_auto_upgrade_interval" {
  description = "Auto upgrade interval"
  type        = number
  default     = 1
}

variable "maintenance_window_auto_upgrade_duration" {
  description = "Auto upgrade duration"
  type        = number
  default     = 4
}

variable "maintenance_window_node_os_frequency" {
  description = "Node OS upgrade frequency"
  type        = string
  default     = "Weekly"
}

variable "maintenance_window_node_os_interval" {
  description = "Node OS upgrade interval"
  type        = number
  default     = 1
}

variable "maintenance_window_node_os_duration" {
  description = "Node OS upgrade duration"
  type        = number
  default     = 4
}

variable "maintenance_window_day_of_week" {
  description = "Day of the week for maintenance window"
  type        = string
  default     = "Monday"
  
}

variable "auto_upgrade_day_of_month" {
  description = "Day of the month for auto upgrade"
  type        = number
  default     = 1
  
}

variable "auto_upgrade_week_index" {
  description = "Week index for auto upgrade"
  type        = string
  default     = "First"
  
}

variable "auto_upgrade_start_date" {
  description = "Start date for auto upgrade"
  type        = string
  default     = "2025-03-31T00:00:00Z"
  
}

variable "auto_upgrade_start_time" {
  description = "Start time for auto upgrade"
  type        = string
  default     = "00:00"
  
}

variable "auto_upgrade_utc_offset" {
  description = "UTC offset for auto upgrade"
  type        = string
  default     = null
  
}

variable "auto_upgrade_end" {
  description = "End time for auto upgrade"
  type        = string
  default     = "2025-03-31T23:59:59Z"
  
}

variable "auto_upgrade_start" {
  description = "Start time for auto upgrade"
  type        = string
  default     = "2025-03-31T00:00:00Z"
  
}

variable "node_os_day_of_week" {
  description = "Day of the week for node OS upgrade"
  type        = string
  default     = "Monday"
  
}

variable "node_os_day_of_month" {
  description = "Day of the month for node OS upgrade"
  type        = number
  default     = 1
  
}

variable "node_os_week_index" {
  description = "Week index for node OS upgrade"
  type        = string
  default     = "First"
  
}

variable "node_os_start_date" {
  description = "Start date for node OS upgrade"
  type        = string
  default     = "2025-03-31T00:00:00Z"
  
}

variable "node_os_start_time" {
  description = "Start time for node OS upgrade"
  type        = string
  default     = "00:00"
  
}

variable "node_os_utc_offset" {
  description = "UTC offset for node OS upgrade"
  type        = string
  default     = null
  
}

variable "node_os_end" {
  description = "End time for node OS upgrade"
  type        = string
  default     = "2025-03-31T23:59:59Z"
  
}

variable "node_os_start" {
  description = "Start time for node OS upgrade"
  type        = string
  default     = "2025-03-31T00:00:00Z"
  
}

variable "microsoft_defender_log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for Microsoft Defender"
  type        = string
  default     = null
}

variable "node_os_upgrade_channel" {
  description = "Node OS upgrade channel"
  type        = string
  default     = "NodeImage"
}

variable "monitor_metrics_annotations" {
  type = string
  default = null
}

variable "monitor_metrics_labels" {
  type = string
  default = null
}

variable "key_vault_secrets_provider_secret_rotation_enabled" {
  description = "Enable secret rotation in Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_secrets_provider_secret_rotation_interval" {
  description = "Secret rotation interval"
  type        = string
  default     = "2m"
}

# variable "key_vault_key_id" {
#   description = "Key Vault Key ID for encryption"
#   type        = string
#   default     = null 
# }

variable "linux_admin_username" {
  description = "Admin username for Linux profile"
  type        = string
  default     = "azureuser"
}

variable "linux_ssh_key" {
  description = "SSH key for Linux profile"
  type        = string
  default     = "123"
}

variable "open_service_mesh_enabled" {
  type    = bool
  default = false
}

variable "workload_autoscaler_profile_kube_reserved_cpus" {
  type    = number
  default = 2
}

variable "workload_autoscaler_profile_kube_reserved_memory_mb" {
  type    = number
  default = 2048
}

variable "workload_autoscaler_profile_system_reserved_cpus" {
  type    = number
  default = 2
}

variable "workload_autoscaler_profile_system_reserved_memory_mb" {
  type    = number
  default = 2048
}

variable "storage_profile_blob_driver_enabled" {
  type    = bool
  default = true
}

variable "storage_profile_disk_driver_enabled" {
  type    = bool
  default = true
}

variable "storage_profile_file_driver_enabled" {
  type    = bool
  default = true
}

variable "support_plan" {
  type    = string
  default = "KubernetesOfficial"
}

variable "windows_profile_admin_username" {
  type    = string
  default = "adminuser"
}

variable "windows_profile_admin_password" {
  type    = string
  sensitive = true
  default = "P@ssw0rd1234!"
}






