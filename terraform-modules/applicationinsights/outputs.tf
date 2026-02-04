output "id" {
  description = "The ID of the Application Insights component."
  value       = azurerm_application_insights.this.id
}

output "app_id" {
  description = "The App ID associated with this Application Insights component."
  value       = azurerm_application_insights.this.app_id
}

output "instrumentation_key" {
  description = "The Instrumentation Key for this Application Insights component."
  value       = azurerm_application_insights.this.instrumentation_key
}

output "connection_string" {
  description = "The Connection String for this Application Insights component."
  value       = azurerm_application_insights.this.connection_string
}
