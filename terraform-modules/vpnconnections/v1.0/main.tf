data "azurerm_virtual_network_gateway" "vgw" {
  for_each            = var.vpn_connections
  name                = each.value.virtual_network_gateway
  resource_group_name = each.value.resource_group_name
}

data "azurerm_local_network_gateway" "lgw" {
  for_each            = var.vpn_connections
  name                = each.value.local_network_gateway
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  for_each                   = var.vpn_connections
  name                       = each.value.name
  location                   = var.main_location
  resource_group_name        = each.value.resource_group_name
  type                       = each.value.type
  virtual_network_gateway_id = data.azurerm_virtual_network_gateway.vgw[each.key].id
  local_network_gateway_id   = data.azurerm_local_network_gateway.lgw[each.key].id
  shared_key                 = each.value.shared_key
  tags                       = each.value.tags
}