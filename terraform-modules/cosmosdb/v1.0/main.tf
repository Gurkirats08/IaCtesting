resource "azurerm_cosmosdb_account" "cosmos_db" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  offer_type                 = var.offer_type
  kind                       = var.kind
  automatic_failover_enabled = var.automatic_failover_enabled
  default_identity_type      = var.default_identity_type
  minimal_tls_version        = var.minimal_tls_version
  capabilities {
    name = var.capability1
  }
  capabilities {
    name = var.capability2
  }
  consistency_policy {
    consistency_level       = var.consistency_level
    max_staleness_prefix    = var.max_staleness_prefix
    max_interval_in_seconds = var.max_interval_in_seconds
  }
  geo_location {
    location          = var.geo_location1
    failover_priority = var.failover_priority1
  }
  analytical_storage {
    schema_type = var.schema_type

  }

  #Optional Parameters------------------------------------------

  analytical_storage_enabled = var.analytical_storage_enabled
  capacity {
    total_throughput_limit = var.total_throughput_limit
  }
  backup {
    type                = var.backup_type
    tier                = var.backup_tier
    interval_in_minutes = var.max_interval_in_minutes
    retention_in_hours  = var.retention_in_hours
    storage_redundancy  = var.storage_redundancy
  }
  dynamic "create_mode" {
    for_each = var.backup_type == "Continuous" && var.create_mode != null ? [1] : []
    content {
      create_mode = var.create_mode
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  ip_range_filter                       = var.ip_range_filter
  free_tier_enabled                     = var.free_tier_enabled
  partition_merge_enabled               = var.partition_merge_enabled
  burst_capacity_enabled                = var.burst_capacity_enabled
  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  managed_hsm_key_id                    = var.managed_hsm_key_id
  multiple_write_locations_enabled      = var.multiple_write_locations_enabled
  access_key_metadata_writes_enabled    = var.access_key_metadata_writes_enabled
  mongo_server_version                  = var.mongo_server_version
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids
  local_authentication_disabled         = var.local_authentication_disabled

  cors_rule {
    allowed_origins    = var.allowed_origins
    max_age_in_seconds = var.max_age_in_seconds
    allowed_methods    = var.allowed_methods
    allowed_headers    = var.allowed_headers
    exposed_headers    = var.exposed_headers
  }

  restore {
    source_cosmosdb_account_id = var.source_cosmosdb_account_id
    restore_timestamp_in_utc   = var.restore_timestamp_in_utc
  }
}
