data "azurerm_monitor_diagnostic_categories" "this" {
  count       = var.logs_categories == null || var.metrics == null ? 1 : 0
  resource_id = var.target_resource_id
}

locals {
  logs_category_type = var.logs_categories == null ? data.azurerm_monitor_diagnostic_categories.this[0].log_category_types : var.logs_categories
  metrics            = var.metrics == null ? data.azurerm_monitor_diagnostic_categories.this[0].metrics : var.metrics
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  dynamic "enabled_log" {
    for_each = local.logs_category_type
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = local.metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
  lifecycle {
    ignore_changes = [ 
      metric,
      enabled_log
    ]
  }
  
}
