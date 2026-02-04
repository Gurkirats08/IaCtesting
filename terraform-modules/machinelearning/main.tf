resource "azurerm_machine_learning_workspace" "this" {
  name                    = var.name
  friendly_name           = var.workspace_display_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id

  identity {
    type = "SystemAssigned"
  }

  // to be added if encryption is required
  #   encryption {
  #     key_vault_id = var.key_vault_id
  #     key_id = var.key_vault_key_id
  #   }
}
