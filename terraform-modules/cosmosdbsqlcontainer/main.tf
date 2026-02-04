resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  account_name          = var.account_name
  database_name         = var.database_name
  partition_key_paths   = var.partition_key_paths
  partition_key_version = var.partition_key_version
}