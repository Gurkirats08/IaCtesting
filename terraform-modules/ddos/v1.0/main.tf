data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.ddos_plans : {}
  name     = each.value.resourceGroupName
}

locals {
  resourcegroup_state_exists = false
}

resource "azurerm_network_ddos_protection_plan" "this" {
  for_each            = var.ddos_plans
  name                = each.value.name
  location            = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  resource_group_name = each.value.resourceGroupName
  tags                = each.value.tags
}
