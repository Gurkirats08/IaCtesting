resource "azurerm_postgresql_flexible_server" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  zone                         = var.zone
  version                      = var.version
  sku_name                     = var.sku_name
  storage_mb                   = var.storage_mb
  storage_tier                 = var.storage_tier
  auto_grow_enabled            = var.auto_grow_enabled
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = var.backup_type != null ? var.create_mode : null
  source_server_id             = contains(["GeoRestore", "PointInTimeRestore", "Replica"], var.create_mode) ? var.source_server_id : null
  point_in_time_restore_time_in_utc = (
    contains(["GeoRestore", "PointInTimeRestore"], var.create_mode) ? var.point_in_time_restore_time_in_utc : null
  )
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = var.public_network_access_enabled
  replication_role              = var.replication_role


  tags = var.tags

  dynamic "authentication" {
    for_each = var.authentication != null ? [1] : []
    content {
      active_directory_auth_enabled = var.authentication.active_directory_auth_enabled
      password_auth_enabled         = var.authentication.password_auth_enabled
      tenant_id                     = var.authentication.tenant_id
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      key_vault_key_id                     = var.customer_managed_key.key_vault_key_id
      primary_user_assigned_identity_id    = var.customer_managed_key.primary_user_assigned_identity_id
      geo_backup_key_vault_key_id          = var.customer_managed_key.geo_backup_key_vault_key_id
      geo_backup_user_assigned_identity_id = var.customer_managed_key.geo_backup_user_assigned_identity_id
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [1] : []
    content {
      day_of_week  = var.maintenance_window.day_of_week
      start_hour   = var.maintenance_window.start_hour
      start_minute = var.maintenance_window.start_minute
    }
  }

  dynamic "high_availability" {
    for_each = var.high_availability != null ? [1] : []
    content {
      mode                      = var.high_availability.mode
      standby_availability_zone = var.high_availability.standby_availability_zone
    }
  }

  administrator_login = (
    var.create_mode == "Default" && var.authentication.password_auth_enabled ? var.administrator_login : null
  )
  administrator_password = (
    var.create_mode == "Default" && var.authentication.password_auth_enabled ? var.administrator_password : null
  )
}
