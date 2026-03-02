data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.automation_accounts : {}
  name     = each.value.resourceGroupName
}

locals {
  resourcegroup_state_exists = false
}


resource "azurerm_automation_account" "this" {
  for_each                      = var.automation_accounts
  name                          = each.value.name
  location                      = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  resource_group_name           = each.value.resourceGroupName
  sku_name                      = each.value.sku
  local_authentication_enabled  = each.value.localAuthenticationEnabled
  public_network_access_enabled = each.value.publicNetworkAccessEnabled == "Enabled" ? true : false

  identity {
    type         = each.value.identityType
    identity_ids = lookup(each.value, "identityIds", null)
  }

  tags = each.value.tags
}
