output "name" {
  description = "The name of the created resource group."
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "The id of the resource created."
  value       = azurerm_virtual_network.this.id
}

output "guid" {
  description = "The GUID of the virtual network."
  value       = azurerm_virtual_network.this.guid
}
