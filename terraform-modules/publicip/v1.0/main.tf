
# -
# - Public IP
# -
# resource "azurerm_public_ip" "this" {
#   for_each            = var.public_IPs
#   name                = lookup(each.value, "bastionIPName", null) != null ? each.value.bastionIPName : each.value.firewallIPName
#   resource_group_name = var.resource_group_name
#   location            = var.main_location
#   allocation_method   = lookup(each.value, "publicIPAllocationMethod", null) != null ? each.value.publicIPAllocationMethod : each.value.firewallIpAllocationMethod
#   zones               = each.value.zones
#   ip_version          = each.value.publicIPAddressVersion
#   sku                 = lookup(each.value, "skuName", null) != null ? each.value.skuName : each.value.firewallSkuName
#   tags                = { environment : var.environment }
# }


# Public IP for various resources, including Bastion, Firewall, and VNet Gateway
resource "azurerm_public_ip" "this" {
  for_each            = var.public_IPs
  name                = lookup(each.value, "bastionIPName", null) != null ? each.value.bastionIPName :lookup(each.value, "firewallIPName", null) != null ? each.value.firewallIPName :lookup(each.value, "gatewayIPName", null) != null ? each.value.gatewayIPName : null
  resource_group_name = var.resource_group_name
  location            = var.main_location
  allocation_method   = lookup(each.value, "publicIPAllocationMethod", null) != null ? each.value.publicIPAllocationMethod :lookup(each.value, "firewallIpAllocationMethod", null) != null ? each.value.firewallIpAllocationMethod :lookup(each.value, "gatewayIpAllocationMethod", null) != null ? each.value.gatewayIpAllocationMethod : null
  zones               = lookup(each.value, "zones", null) != null ? each.value.zones : []
  ip_version          = lookup(each.value, "publicIPAddressVersion", "IPv4")
  sku                 = lookup(each.value, "skuName", null) != null ? each.value.skuName :lookup(each.value, "firewallSkuName", null) != null ? each.value.firewallSkuName :lookup(each.value, "gatewaySkuName", null) != null ? each.value.gatewayipSku : "Standard"
  tags                = { environment : var.environment }
}
