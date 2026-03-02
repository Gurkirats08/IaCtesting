output "name" {
  description = "The name of the resoruce created."
  value       = azurerm_subnet.this.name
}

output "id" {
  description = "The id of the resource created."
  value       = azurerm_subnet.this.id
}
