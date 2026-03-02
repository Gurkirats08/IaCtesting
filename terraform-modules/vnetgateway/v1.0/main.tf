data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.vnet_gateways : {}
  name     = each.value.resourceGroupName
}

locals {
  resourcegroup_state_exists = false
}

resource "azurerm_virtual_network_gateway" "this" {
  for_each            = var.vnet_gateways
  name                = each.value.name
  location            = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  resource_group_name = each.value.resourceGroupName
  type                = each.value.type
  vpn_type            = each.value.vpnType
  active_active       = false
  enable_bgp          = each.value.enableBGP
  sku                 = each.value.gatewaySku
  tags                = each.value.gatewayTags
  ip_configuration {
    name                          = each.value.gatewayIpConfig
    public_ip_address_id          = var.public_ip_ids[each.value.name].id
    private_ip_address_allocation = each.value.privateIpAddressAllocation
    subnet_id                     = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${each.value.resourceGroupName}/providers/Microsoft.Network/virtualNetworks/${each.value.vNetName}/subnets/GatewaySubnet"
  }
}
