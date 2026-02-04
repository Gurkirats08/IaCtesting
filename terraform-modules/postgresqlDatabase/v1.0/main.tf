resource "azurerm_postgresql_database" "name" {
  name                = var.name
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  charset             = var.charset
  collation           = var.collation


  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}