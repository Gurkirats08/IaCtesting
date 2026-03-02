
# -
# - Public IP
# -
resource "azurerm_public_ip" "this" {
  for_each            = var.public_IPs
  name                = lookup(each.value, "bastionIPName", null) != null ? each.value.bastionIPName : each.value.firewallIPName
  resource_group_name = var.resource_group_name
  location            = var.main_location
  allocation_method   = lookup(each.value, "publicIPAllocationMethod", null) != null ? each.value.publicIPAllocationMethod : each.value.firewallIpAllocationMethod
  zones               = each.value.zones
  ip_version          = each.value.publicIPAddressVersion
  sku                 = lookup(each.value, "skuName", null) != null ? each.value.skuName : each.value.firewallSkuName
  tags                = { environment : var.environment }
}
