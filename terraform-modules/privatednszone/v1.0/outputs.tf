output "id" {
  value       = azurerm_private_dns_zone.this.id
  description = "The Private DNS Zone ID."
}

output "name" {
  value       = azurerm_private_dns_zone.this.name
  description = "The Private DNS Zone name."
}