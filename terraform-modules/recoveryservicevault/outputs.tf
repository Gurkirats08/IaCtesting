output "id" {
  description = "The ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.id
}

output "identity" {
  description = "The Managed Service Identity."
  value       = azurerm_recovery_services_vault.this.identity
}