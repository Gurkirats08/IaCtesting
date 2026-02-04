output "name" {
  description = "Specifies the name of the Route table"
  value       = azurerm_route_table.this.name
}

output "id" {
  description = "Specifies the id of the Route table"
  value       = azurerm_route_table.this.id
}
