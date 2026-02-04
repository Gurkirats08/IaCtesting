resource "azurerm_route_table" "this" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
//  disable_bgp_route_propagation = coalesce(var.route_table.disable_bgp_route_propagation, null)
  bgp_route_propagation_enabled = coalesce(var.route_table.bgp_route_propagation_enabled, null)
  tags                          = merge(local.tags, var.tags)

  dynamic "route" {
    for_each = coalesce(var.route_table.routes, [])
    content {
      name                   = coalesce(route.value.name, null)
      address_prefix         = coalesce(route.value.addressPrefix, null)
      next_hop_type          = coalesce(route.value.nextHopType, null)
      next_hop_in_ip_address = route.value.NextHopIpAddress
    }
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

