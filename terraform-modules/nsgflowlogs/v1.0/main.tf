# data "azurerm_log_analytics_workspace" "this" {
#   name                = var.log_analytics_workspace_name
#   resource_group_name = var.log_analytics_resource_group
# }

resource "azurerm_network_watcher_flow_log" "test" {
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.resource_group_name
  name                 = var.nsg_flow_log_name
  location             = var.location

  network_security_group_id = var.nsg_id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.workspace_resource_id
    interval_in_minutes   = 10
  }
}
