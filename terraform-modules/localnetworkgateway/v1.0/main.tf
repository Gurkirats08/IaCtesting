# data "azurerm_resource_group" "this" {
#   for_each = local.resourcegroup_state_exists == false ? var.local_network_gateways : {}
#   name     = each.value.resourceGroupName
# }

# locals {
#   resourcegroup_state_exists = false
# }

resource "azurerm_local_network_gateway" "example" {
  for_each            = var.local_network_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = var.main_location
  gateway_address     = each.value.gateway_address
  address_space       = each.value.address_space
  tags                = each.value.tags
}