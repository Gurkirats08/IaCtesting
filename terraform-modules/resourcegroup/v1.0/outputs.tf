output "name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "The ID of the Resource Group."
  value       = azurerm_resource_group.this.id
}
