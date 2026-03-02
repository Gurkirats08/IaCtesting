resource "azurerm_network_watcher" "this" {
  name                = var.network_watcher_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
