resource "azurerm_sentinel_log_analytics_workspace_onboarding" "this" {
  workspace_id                 = var.workspace_id
  customer_managed_key_enabled = var.is_cmk_enabled
}
