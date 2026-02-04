resource "azurerm_management_lock" "lock" {
  name       = var.name
  lock_level = var.lock_level
  notes      = var.notes

  scope = try(
    "subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/${var.resource_type}/${var.resource_name}",
    "subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}",var.subscription_id
  )
}