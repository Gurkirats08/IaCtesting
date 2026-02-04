data "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = var.backupvaultname
  resource_group_name = var.resource_group_name
}

resource "azurerm_data_protection_backup_policy_blob_storage" "backup_policy_blob_storage" {
  name                                   = var.backup_policy_name
  vault_id                               = var.backup_vault_id
  operational_default_retention_duration = var.vault_default_retention_duration
}

resource "azurerm_data_protection_backup_instance_blob_storage" "name" {
  name               = var.backup_instance_name
  vault_id           = var.backup_vault_id
  location           = var.location
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.backup_policy_blob_storage.id
  storage_account_id = var.storage_account_id
  depends_on         = [azurerm_data_protection_backup_policy_blob_storage.backup_policy_blob_storage, azurerm_role_assignment.rbac]
}

resource "azurerm_role_assignment" "rbac" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id
}
