resource "azurerm_storage_account" "this" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_kind                     = var.account_kind
  account_tier                     = var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  access_tier                      = var.access_tier
  # enable_https_traffic_only        = var.enable_https_traffic_only
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  allowed_copy_scope              = var.allowed_copy_scope
  sftp_enabled                    = var.sftp_enabled


  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]

  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_name == null ? [] : [1]
    content {
      name          = var.custom_domain_name
      use_subdomain = var.use_sub_domain_name
    }
  }

  default_to_oauth_authentication = var.default_to_oauth_authentication
  is_hns_enabled                  = false

  nfsv3_enabled = false

  dynamic "customer_managed_key" {
    for_each = var.key_vault_key_id == null ? [] : [1]
    content {
      # key_vault_key_id          = var.key_vault_key_id
      managed_hsm_key_id        = var.key_vault_key_id
      user_assigned_identity_id = var.user_assigned_identity_id

    }
  }
  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [1]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties_enabled ? [1] : []
    content {

      dynamic "delete_retention_policy" {

        for_each = var.delete_retention_policy_enabled ? [1] : []
        content {
          days = var.delete_retention_days
        }
      }

      versioning_enabled            = var.versioning_enabled
      change_feed_enabled           = var.change_feed_enabled
      change_feed_retention_in_days = var.change_feed_retention_in_days

      dynamic "cors_rule" {
        for_each = length(var.allowed_headers) > 0 ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
        }
      }

      dynamic "restore_policy" {
        for_each = var.delete_retention_policy_enabled && var.versioning_enabled && var.change_feed_enabled ? [1] : []

        content {
          days = var.restore_policy_days > var.delete_retention_days ? var.restore_policy_days : var.delete_retention_days - 1
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties_enabled ? [1] : []
    content {

      dynamic "cors_rule" {
        for_each = length(var.allowed_headers) > 0 ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = var.logging_enabled ? [1] : []
        content {
          delete                = var.delete
          read                  = var.read
          version               = var.storage_analytics_version
          write                 = var.write
          retention_policy_days = var.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = var.minute_metrics_enabled ? [1] : []
        content {
          enabled               = var.minute_metrics_enabled
          version               = var.storage_analytics_version
          include_apis          = var.minute_metrics_include_apis
          retention_policy_days = var.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = var.hour_metrics_enabled == true ? [1] : []
        content {
          enabled               = var.hour_metrics_enabled
          version               = var.storage_analytics_version
          include_apis          = var.hour_metrics_include_apis
          retention_policy_days = var.retention_policy_days
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_enabled ? [1] : []
    content {
      index_document     = var.index_document
      error_404_document = var.error_404_document
    }
  }

  dynamic "share_properties" {
    for_each = var.share_properties_enabled ? [1] : []
    content {

      dynamic "cors_rule" {
        for_each = length(var.allowed_headers) > 0 ? [1] : []
        content {
          allowed_headers    = var.allowed_headers
          allowed_methods    = var.allowed_methods
          allowed_origins    = var.allowed_origins
          exposed_headers    = var.exposed_headers
          max_age_in_seconds = var.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.retention_days_enaled ? [1] : []
        content {
          days = var.retention_days
        }
      }

      dynamic "smb" {
        for_each = var.smb_enabled ? [1] : []
        content {
          versions             = var.smb_versions
          authentication_types = var.authentication_types
          multichannel_enabled = var.multichannel_enabled
        }
      }
    }
  }

  # local_user_enabled                = var.local_user_enabled
  # queue_encryption_key_type         = var.account_kind == "StorageV2" ? var.queue_encryption_key_type : "Service"
  # table_encryption_key_type         = var.account_kind == "StorageV2" ? var.table_encryption_key_type : "Service"
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  dynamic "immutability_policy" {
    for_each = var.allow_protected_append_writes ? [1] : []
    content {
      allow_protected_append_writes = var.allow_protected_append_writes
      state                         = var.state
      period_since_creation_in_days = var.period_since_creation_in_days
    }
  }

  dynamic "sas_policy" {
    for_each = var.expiration_period == null ? [] : [1]
    content {
      expiration_period = var.expiration_period
      expiration_action = var.expiration_action
    }
  }

  tags = var.tags

  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication_enabled ? [1] : []
    content {
      directory_type = var.directory_type
      active_directory {
        domain_name         = var.azure_files_domain_name
        domain_guid         = var.azure_files_domain_guid
        domain_sid          = var.directory_type == "AD" ? var.domain_sid : null
        storage_sid         = var.directory_type == "AD" ? var.storage_sid : null
        forest_name         = var.directory_type == "AD" ? var.forest_name : null
        netbios_domain_name = var.directory_type == "AD" ? var.netbios_domain_name : null
      }
    }
  }

  dynamic "routing" {
    for_each = var.routing_enabled ? [1] : []
    content {
      publish_internet_endpoints  = var.publish_internet_endpoints
      publish_microsoft_endpoints = var.publish_microsoft_endpoints
      choice                      = var.routing_choice
    }
  }
  lifecycle {
    ignore_changes = [customer_managed_key]
  }
}

/*
resource "null_resource" "disable_blob_public_access" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
      az account list --query "[?isDefault]"
      az storage account update --name ${azurerm_storage_account.this.name} --resource-group ${azurerm_storage_account.this.resource_group_name} --allow-blob-public-access false
    EOT
  } */

//   depends_on = [azurerm_storage_account.this]
// }