resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  name                    = var.user_node_pool_name
  vm_size                 = var.user_node_pool_vm_size
  kubernetes_cluster_id   = var.user_node_pool_kubernetes_cluster_id
  zones                   = var.user_node_pool_availability_zones
  auto_scaling_enabled    = var.user_node_pool_enable_auto_scaling
  max_pods                = var.user_node_pool_max_pods
  os_disk_size_gb         = var.user_node_pool_os_disk_size_gb
  mode                    = var.user_node_pool_mode
  os_disk_type            = var.user_node_pool_os_disk_type
  node_count              = var.user_node_pool_node_count
  min_count               = var.user_node_pool_min_count
  max_count               = var.user_node_pool_max_count
  vnet_subnet_id          = var.user_node_pool_vnet_subnet_id
  host_encryption_enabled = true
  tags                    = var.tags

  upgrade_settings {
    drain_timeout_in_minutes      = var.drain_timeout_in_minutes
    node_soak_duration_in_minutes = var.node_soak_duration_in_minutes
    max_surge                     = var.max_surge
  }

  lifecycle {
    ignore_changes = [
      upgrade_settings[0].drain_timeout_in_minutes,
      upgrade_settings[0].node_soak_duration_in_minutes,
      upgrade_settings[0].max_surge
    ]
  }
}
