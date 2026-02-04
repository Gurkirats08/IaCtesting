
resource "azurerm_kubernetes_cluster" "aks" {
  name                             = var.name
  oidc_issuer_enabled              = var.oidc_issuer_enabled
  workload_identity_enabled        = var.workload_identity_enabled
  resource_group_name              = var.resource_group_name
  location                         = var.location
  sku_tier                         = var.sku_tier
  dns_prefix                       = var.dns_prefix
  private_cluster_enabled          = true
  private_dns_zone_id              = var.private_dns_zone_id
  kubernetes_version               = var.kubernetes_version
  automatic_upgrade_channel        = var.automatic_channel_upgrade
  node_resource_group              = var.node_resource_group
  azure_policy_enabled             = var.azure_policy_enabled
  cost_analysis_enabled            = var.cost_analysis_enabled
  disk_encryption_set_id           = var.disk_encryption_set_id
  edge_zone                        = var.edge_zone
  http_application_routing_enabled = var.http_application_routing_enabled
  image_cleaner_enabled            = var.image_cleaner_enabled
  image_cleaner_interval_hours     = var.image_cleaner_interval_hours
  local_account_disabled           = var.local_account_disabled
  node_os_upgrade_channel          = var.node_os_upgrade_channel
  open_service_mesh_enabled        = var.open_service_mesh_enabled
  support_plan                     = var.support_plan

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  default_node_pool {
    name                         = var.default_node_pool_name
    vm_size                      = var.default_node_pool_vm_size
    type                         = "VirtualMachineScaleSets"
    zones                        = var.default_node_pool_availability_zones
    auto_scaling_enabled         = var.default_node_pool_enable_auto_scaling
    max_pods                     = var.default_node_pool_max_pods
    os_disk_size_gb              = var.default_node_pool_os_disk_size_gb
    os_disk_type                 = var.default_node_pool_os_disk_type
    host_encryption_enabled      = var.default_node_pool_enable_host_encryption
    only_critical_addons_enabled = var.default_node_pool_only_critical_addons_enabled
    node_count                   = var.default_node_pool_node_count
    min_count                    = var.default_node_pool_min_count
    max_count                    = var.default_node_pool_max_count
    vnet_subnet_id               = var.default_node_pool_vnet_subnet_id

    upgrade_settings {
      drain_timeout_in_minutes      = var.drain_timeout_in_minutes
      node_soak_duration_in_minutes = var.node_soak_duration_in_minutes
      max_surge                     = var.max_surge
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_policy      = var.network_policy
    network_plugin_mode = var.network_plugin_mode
    service_cidr        = var.service_address_range
    dns_service_ip      = var.dns_ip
    pod_cidr            = var.pod_cidr
    load_balancer_sku   = "standard"
    outbound_type       = var.outbound_type

    load_balancer_profile {
      outbound_ports_allocated  = var.outbound_ports_allocated
      idle_timeout_in_minutes   = var.idle_timeout_in_minutes
      managed_outbound_ip_count = var.managed_outbound_ip_count
    }
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = var.azure_rbac_enabled
    tenant_id              = var.tenant_id
  }

  #optional Blocks----
  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  http_proxy_config {
    http_proxy  = var.http_proxy
    https_proxy = var.https_proxy
    no_proxy    = var.no_proxy
  }

  # ingress_application_gateway {
  #   subnet_id    = var.ingress_application_gateway_subnet_id
  #   gateway_id   = var.ingress_application_gateway_id
  #   subnet_cidr  = var.ingress_application_gateway_subnet_cidr
  #   gateway_name = var.ingress_application_gateway_name
  # }

  kubelet_identity {
    client_id                 = var.kubelet_identity_client_id
    object_id                 = var.kubelet_identity_object_id
    user_assigned_identity_id = var.kubelet_identity_user_assigned_identity_id
  }

  maintenance_window {
    allowed {
      day   = var.maintenance_window_day
      hours = var.maintenance_window_hours
    }
  }

  maintenance_window_auto_upgrade {
    frequency    = var.maintenance_window_auto_upgrade_frequency
    interval     = var.maintenance_window_auto_upgrade_interval
    duration     = var.maintenance_window_auto_upgrade_duration
    day_of_week  = var.maintenance_window_day_of_week
    day_of_month = var.auto_upgrade_day_of_month
    week_index   = var.auto_upgrade_week_index
    start_date   = var.auto_upgrade_start_date
    start_time   = var.auto_upgrade_start_time
    utc_offset   = var.auto_upgrade_utc_offset
    not_allowed {
      end   = var.auto_upgrade_end
      start = var.auto_upgrade_start
    }

  }

  maintenance_window_node_os {
    frequency    = var.maintenance_window_node_os_frequency
    interval     = var.maintenance_window_node_os_interval
    duration     = var.maintenance_window_node_os_duration
    day_of_week  = var.node_os_day_of_week
    day_of_month = var.node_os_day_of_month
    week_index   = var.node_os_week_index
    start_date   = var.node_os_start_date
    start_time   = var.node_os_start_time
    utc_offset   = var.node_os_utc_offset
    not_allowed {
      end   = var.node_os_end
      start = var.node_os_start
    }

  }

  monitor_metrics {
    annotations_allowed = var.monitor_metrics_annotations
    labels_allowed      = var.monitor_metrics_labels
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = var.key_vault_secrets_provider_secret_rotation_enabled
    secret_rotation_interval = var.key_vault_secrets_provider_secret_rotation_interval
  }

  # key_management_service {
  #   key_vault_key_id = var.key_vault_key_id

  # }

  linux_profile {
    admin_username = var.linux_admin_username
    ssh_key {
      key_data = var.linux_ssh_key
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = var.balance_similar_node_groups
    max_graceful_termination_sec     = var.max_graceful_termination_sec
    scale_down_delay_after_add       = var.scale_down_delay_after_add
    scale_down_delay_after_delete    = var.scale_down_delay_after_delete
    scale_down_delay_after_failure   = var.scale_down_delay_after_failure
    scan_interval                    = var.scan_interval
    scale_down_unneeded              = var.scale_down_unneeded
    scale_down_unready               = var.scale_down_unready
    scale_down_utilization_threshold = var.scale_down_utilization_threshold
  }

  storage_profile {
    blob_driver_enabled = var.storage_profile_blob_driver_enabled
    disk_driver_enabled = var.storage_profile_disk_driver_enabled
    file_driver_enabled = var.storage_profile_file_driver_enabled
  }

  windows_profile {
    admin_username = var.windows_profile_admin_username
    admin_password = var.windows_profile_admin_password
  }

  tags = var.tags



  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings,
      azure_policy_enabled,
      automatic_upgrade_channel,
      api_server_access_profile,
      maintenance_window,
      maintenance_window_auto_upgrade,
      http_proxy_config,
      ingress_application_gateway,
      key_management_service,
      key_vault_secrets_provider,
      kubelet_identity,
      linux_profile,
      monitor_metrics,
      microsoft_defender,
      storage_profile,
      windows_profile
    ]
  }
}
