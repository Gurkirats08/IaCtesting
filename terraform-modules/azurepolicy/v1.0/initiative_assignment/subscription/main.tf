resource "azurerm_subscription_policy_assignment" "set" {
  for_each             = { for key, val in var.policy_assignments : "${val.name}|${val.subscription_id}" => val if val.subscription_id != null && val.management_group_id == null }
  name                 = each.value.name
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = local.parameters[each.key]
  subscription_id      = each.value.subscription_id
  enforce              = each.value.enforce
  policy_definition_id = each.value.policy_definition_id
  location             = each.value.location
  identity {
    type = "SystemAssigned"
  }
}
