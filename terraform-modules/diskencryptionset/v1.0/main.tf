# resource "azurerm_key_vault_access_policy" "des_access" {
#   key_vault_id = var.key_vault_id
#   tenant_id    = azurerm_disk_encryption_set.this.identity[0].tenant_id
#   object_id    = azurerm_disk_encryption_set.this.identity[0].principal_id

#   key_permissions = [
#     "Get",
#     "UnwrapKey",
#     "WrapKey",
#   ]
# }

resource "azurerm_disk_encryption_set" "this" {
  name                = var.disk_encryption_set_name
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = var.key_id
  encryption_type     = "EncryptionAtRestWithPlatformAndCustomerKeys"

  identity {
    identity_ids = var.user_assigned_identity
    type = "UserAssigned"
  }

}

