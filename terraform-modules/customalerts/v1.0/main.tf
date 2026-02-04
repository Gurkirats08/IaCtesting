resource "azurerm_monitor_action_group" "group" {
  for_each = var.action_groups

  name                = each.value.action_group_name
  resource_group_name = each.value.action_group_rg_name
  short_name          = each.value.action_group_short_name
  enabled             = each.value.action_group_enabled
  tags                = each.value.tags

  dynamic "email_receiver" {
    for_each = each.value.action_group_email_receiver
    content {
      name                    = email_receiver.value["name"]
      email_address           = email_receiver.value["email_address"]
      use_common_alert_schema = email_receiver.value["use_common_alert_schema"]
    }
  }

}

resource "azurerm_monitor_metric_alert" "metric_alert" {
  for_each                 = var.metric_alerts
  name                     = each.value.alert_name
  resource_group_name      = each.value.alert_rg_name
  scopes                   = each.value.alert_scopes
  description              = each.value.alert_description
  tags                     = each.value.tags
  enabled                  = each.value.alert_enabled
  severity                 = each.value.severity
  frequency                = each.value.alert_frequency
  window_size              = each.value.alert_window_size
  target_resource_type     = each.value.alert_target_resource_type
  target_resource_location = each.value.alert_target_resource_location

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold


  }
  action {
    action_group_id = azurerm_monitor_action_group.group[each.value.action_group_name].id
  }

  depends_on = [ azurerm_monitor_action_group.group ]

}

resource "azurerm_monitor_activity_log_alert" "log_alert" {
  for_each            = var.activity_log_alerts
  name                = each.value.alert_name
  resource_group_name = each.value.alert_rg_name
  location            = each.value.location
  scopes              = each.value.alert_scopes
  description         = each.value.description
  tags                = each.value.tags

  criteria {
    operation_name = each.value.operation_name
    category       = each.value.category
    resource_group = each.value.alert_rg_name
  }

  action {
    action_group_id = azurerm_monitor_action_group.group[each.value.action_group_name].id
  }

  depends_on = [ azurerm_monitor_action_group.group ]
  
}
resource "azurerm_monitor_activity_log_alert" "service_health_alert" {
  for_each            = var.service_health_alerts
  name                = each.value.alert_name
  resource_group_name = each.value.alert_rg_name
  location            = each.value.location
  scopes              = each.value.alert_scopes
  description         = each.value.description
  tags                = each.value.tags

  criteria {
    category = each.value.category

    service_health {
      events    = each.value.service_health_events
      locations = each.value.service_health_locations
      services  = each.value.service_health_services
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.group[each.value.action_group_name].id
  }

  depends_on = [ azurerm_monitor_action_group.group ]
  
}