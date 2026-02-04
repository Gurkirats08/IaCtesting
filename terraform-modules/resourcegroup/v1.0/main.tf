resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
