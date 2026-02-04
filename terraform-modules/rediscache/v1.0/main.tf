resource "azurerm_redis_cache" "this" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  capacity                           = var.capacity
  family                             = var.redis_family
  sku_name                           = var.sku
  non_ssl_port_enabled               = var.enable_non_ssl_port
  minimum_tls_version                = var.minimum_tls_version
  public_network_access_enabled      = var.public_network_access_enabled
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  replicas_per_master                = var.sku == "Premium" ? var.replicas_per_master : null
  shard_count                        = var.sku == "Premium" ? var.shard_count : null
  subnet_id                          = var.sku == "Premium" ? var.subnet_id : null
  zones                              = var.zones
  redis_version                      = var.redis_version
  tags                               = var.tags


  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  redis_configuration {
    authentication_enabled          = var.aunthentication_enabled
    maxfragmentationmemory_reserved = (var.sku == "Premium" || var.sku == "Standard") ? lookup(var.redis_configuration, "maxfragmentationmemory_reserved", null) : null
    maxmemory_delta                 = (var.sku == "Premium" || var.sku == "Standard") ? lookup(var.redis_configuration, "maxmemory_delta", null) : null
    maxmemory_policy                = lookup(var.redis_configuration, "maxmemory_policy", null)
    maxmemory_reserved              = (var.sku == "Premium" || var.sku == "Standard") ? lookup(var.redis_configuration, "maxmemory_reserved", null) : null
    aof_backup_enabled              = var.sku == "Premium" ? var.enable_aof_backup : false
    notify_keyspace_events          = (var.sku == "Premium") ? lookup(var.redis_configuration, "notify_keyspace_events", "") : ""
    rdb_backup_enabled              = var.sku == "Premium"  ? true : false
    rdb_backup_frequency            = var.sku == "Premium"  ? var.data_persistence_backup_frequency : null
    rdb_backup_max_snapshot_count   = var.sku == "Premium"  ? var.data_persistence_backup_max_snapshot_count : null
    rdb_storage_connection_string   = var.sku == "Premium"  ? var.primary_blob_connection_string : null

  }


  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    ignore_changes = [
      redis_configuration,
      redis_configuration.0.rdb_storage_connection_string
      ]
  }


}
