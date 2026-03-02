output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.this.id
}

output "disk_encryption_set_versionless_id" {
  value = azurerm_disk_encryption_set.this.versionless_id
}