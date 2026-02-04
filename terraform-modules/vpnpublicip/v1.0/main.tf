data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.vpn_ips : {}
  name     = each.value.resourceGroupName
}

locals {
  resourcegroup_state_exists = false
}

resource "azurerm_public_ip" "this" {
  for_each            = var.vpn_ips
  name                = each.value.vpnIpName
  resource_group_name = each.value.resourceGroupName
  location            = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  allocation_method   = each.value.ipAllocationMethod
  sku                 = each.value.ipSku
  tags                = each.value.ipTags
}
