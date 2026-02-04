resource "azurerm_virtual_network_gateway" "this" {
  for_each            = var.vnet_gateways
  name                = each.value.VnetGatewayName
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = each.value.type
  vpn_type            = each.value.vpnType
  active_active       = false
  enable_bgp          = each.value.enableBGP
  sku                 = each.value.gatewaySkuName
  tags                = each.value.gatewayTags
  ip_configuration {
    name                          = "${each.value.vnetName}-${each.value.VnetGatewayName}-IPConfig"
    public_ip_address_id          = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${each.value.publicipRG}/providers/Microsoft.Network/publicIPAddresses/${each.value.gatewayIPName}"
    private_ip_address_allocation = each.value.privateIpAddressAllocation
    subnet_id                     = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${each.value.subnetRG}/providers/Microsoft.Network/virtualNetworks/${each.value.vnetName}/subnets/gatewaysubnet"
  }
}

