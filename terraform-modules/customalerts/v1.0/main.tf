resource "azurerm_monitor_action_group" "monitor" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name
  tags                = var.tags

}

resource "azurerm_monitor_metric_alert" "alert" {
  name                 = var.alert_name
  resource_group_name  = var.resource_group_name
  scopes               = var.scopes
  description          = var.description
  enabled              = var.enabled
  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.aggregation
    operator         = var.operator
    threshold        = var.threshold
  }
  action {
    action_group_id = azurerm_monitor_action_group.monitor.id

  }
  depends_on = [ azurerm_monitor_action_group.monitor ]
}

