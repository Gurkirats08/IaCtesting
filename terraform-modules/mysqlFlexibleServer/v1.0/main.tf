resource "azurerm_mysql_flexible_server" "server" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.version
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  #public_network_access is automatically set to Disabled if the values are provided for delegated_subnet_id and private_dns_zone_id
  delegated_subnet_id               = var.delegated_subnet_id
  private_dns_zone_id               = var.private_dns_zone_id
  zone                              = var.zone
  sku_name                          = var.sku_name
  create_mode                       = var.create_mode
  source_server_id                  = var.source_server_id
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc
  replication_role                  = var.replication_role

  storage {
    auto_grow_enabled  = var.storage_auto_grow_enabled # Must be true if HA is enabled
    io_scaling_enabled = var.storage_io_scaling_enabled
    iops               = var.storage_iops
    size_gb            = var.storage_size_gb
  }

  high_availability {
    mode                      = var.ha_mode
    standby_availability_zone = var.ha_standby_availability_zone
  }

  maintenance_window {
    day_of_week  = var.maintenance_day_of_week
    start_hour   = var.maintenance_start_hour
    start_minute = var.maintenance_start_minute
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  customer_managed_key {
    key_vault_key_id                     = var.key_vault_key_id
    primary_user_assigned_identity_id    = var.primary_user_assigned_identity_id
    geo_backup_key_vault_key_id          = var.geo_backup_key_vault_key_id
    geo_backup_user_assigned_identity_id = var.geo_backup_user_assigned_identity_id
  }

  tags = var.tags
}
