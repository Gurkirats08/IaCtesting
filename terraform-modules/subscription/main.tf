// Find billing scope id for enrollment account
data "azurerm_billing_enrollment_account_scope" "this" {
  billing_account_name    = var.billingAccountName
  enrollment_account_name = var.enrollmentAccountName
}

// Create subscription alias
resource "azurerm_subscription" "this" {
  for_each          = var.platformSubscriptions
  subscription_name = each.value.displayName
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.this.id
  alias             = each.value.aliasName
  workload          = each.value.workloadType
  tags              = each.value.tags
}

// Associating a subscription with a management group (optional) 
resource "azurerm_management_group_subscription_association" "this" {
  for_each            = { for k, v in var.platformSubscriptions : k => v if v.managementGroupId != null }
  management_group_id = each.value.managementGroupId
  subscription_id     = azurerm_subscription.this[each.value.displayName].subscription_id
}
