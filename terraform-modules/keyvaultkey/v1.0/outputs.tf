output "id" {  
    value       = azurerm_key_vault_key.this.id  
    description = "The ID of the created Key Vault Key."
}

output "name" {  
    value       = azurerm_key_vault_key.this.name  
    description = "The name of the created Key Vault Key."
}