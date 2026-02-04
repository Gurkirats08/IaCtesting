resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = flatten([var.address_space])
  dns_servers         = flatten([var.dns_servers])
  tags                = merge(local.tags, var.tags)

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_ddos_id == null ? [] : [1]
    content {
      id     = var.ddos_protection_plan_ddos_id
      enable = true
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

