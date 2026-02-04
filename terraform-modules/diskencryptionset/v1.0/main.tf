resource "azurerm_disk_encryption_set" "this" {
  name                = var.disk_encryption_set_name
  location            = var.location
  resource_group_name = var.resource_group_name
  encryption_type     = "EncryptionAtRestWithPlatformAndCustomerKeys"
  managed_hsm_key_id  = var.key_id
  identity {
    identity_ids = var.user_assigned_identity
    type         = "UserAssigned"
  }
   auto_key_rotation_enabled = var.auto_key_rotation_enabled

}

