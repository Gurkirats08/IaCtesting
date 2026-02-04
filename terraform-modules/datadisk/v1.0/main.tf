# Create the managed disk
resource "azurerm_managed_disk" "data_disk" {
  name                   = var.disk_name
  location               = var.location
  resource_group_name    = var.resource_group
  storage_account_type   = var.storage_account_type
  disk_size_gb           = var.disk_size_gb
  create_option          = "Empty"
  disk_encryption_set_id = var.disk_encryption_set_id

}

