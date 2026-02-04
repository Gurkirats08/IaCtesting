resource "azurerm_key_vault" "this" {
  name                            = var.key_vault_name
  location                        = var.key_vault_location
  resource_group_name             = var.resource_group_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enabled_for_rbac_authorization
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  sku_name                        = var.sku_name
  tenant_id = var.tenant_id
  public_network_access_enabled   = var.public_network_access_enabled
  timeouts {
    create = "30m"
    read   = "10m"
    update = "30m"
    delete = "30m"
  }
  dynamic access_policy {
    for_each = var.access_policy
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id
      application_id = access_policy.value.application_id
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions = access_policy.value.key_permissions
      secret_permissions = access_policy.value.secret_permissions
      storage_permissions = access_policy.value.storage_permissions
    }
  }

  dynamic network_acls {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "acr-diagnostic-${var.key_vault_name}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
 
  metric {
    category = "AllMetrics"
    enabled  = true
  }
  enabled_log {
    category = "AuditEvent"
  }
  depends_on = [azurerm_key_vault.this]
}
 