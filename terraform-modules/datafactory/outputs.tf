output "data_factory_id" {
  description = "Data factory id"
  value       = azurerm_data_factory.this.id
}

output "data_factory_name" {
  description = "Data factory name"
  value       = azurerm_data_factory.this.name
}

output "data_factory_managed_identity" {
  description = "System-managed identity"
  value       = azurerm_data_factory.this.identity[0]
}

output "data_factory_managed_user_assigned_identity_id" {
  description = "User-assigned identity"
  value       = length(resource.azurerm_user_assigned_identity.adf_user_managed_identity) > 0 ? resource.azurerm_user_assigned_identity.adf_user_managed_identity[0].id : null
}

output "data_factory_managed_user_assigned_identity_name" {
  description = "User-assigned identity"
  value       = length(resource.azurerm_user_assigned_identity.adf_user_managed_identity) > 0 ? resource.azurerm_user_assigned_identity.adf_user_managed_identity[0].name : null
}

output "data_factory_integration_runtime_id" {
  description = "Data factory integration runtime id"
  value       = local.integration_runtime_id
}

output "data_factory_self_hosted_integration_runtime_primary_authorization_key" {
  description = "The self hosted integration runtime primary authentication key"
  value       = { for ir_k, ir_v in azurerm_data_factory_integration_runtime_self_hosted.integration_runtime : ir_k => ir_v.primary_authorization_key }
  sensitive   = true
}

output "data_factory_self_hosted_integration_runtime_secondary_authorization_key" {
  description = "The self hosted integration runtime secondary authentication key"
  value       = { for ir_k, ir_v in azurerm_data_factory_integration_runtime_self_hosted.integration_runtime : ir_k => ir_v.secondary_authorization_key }
  sensitive   = true
}
