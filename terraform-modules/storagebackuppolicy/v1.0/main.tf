data "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = var.backup_vault_name
  resource_group_name = var.backup_resource_group_name
}

resource "azurerm_data_protection_backup_policy_blob_storage" "backup_policy_blob_storage" {
  name       = var.backup_policy_name
  vault_id   = data.azurerm_data_protection_backup_vault.backup_vault.id
}

resource "azurerm_data_protection_backup_instance_blob_storage" "backup_instance_blob_storage" {
  name               = var.backup_instance_name
  location           = var.location
  storage_account_id = var.storage_account_id
  vault_id           = data.azurerm_data_protection_backup_vault.backup_vault.id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.backup_policy_blob_storage.id
  depends_on         = [azurerm_data_protection_backup_policy_blob_storage.backup_policy_blob_storage]

}
