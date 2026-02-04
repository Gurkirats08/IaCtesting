data "azurerm_mssql_server" "this" {
  resource_group_name = split("/", var.resource_group_id)[4]
  name                = var.mssql_server_name

  depends_on = [
    azapi_resource.this
  ]
}

output "id" {
  value       = azapi_resource.this.id # could be data.azurerm_mssql_server.this.id
  description = "The Microsoft SQL Server ID."
}

output "name" {
  value       = azapi_resource.this.name # could be data.azurerm_mssql_server.this.name
  description = "The Microsoft SQL Server Name."
}

output "fully_qualified_domain_name" {
  value       = data.azurerm_mssql_server.this.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server."
}
