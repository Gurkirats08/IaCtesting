resource "azurerm_management_group" "this" {
  for_each                   = var.platformManagementGroups
  display_name               = each.value.displayName
  parent_management_group_id = lookup(each.value, "parentId", null)
  subscription_ids           = lookup(each.value, "subscriptionIds", [])
}
