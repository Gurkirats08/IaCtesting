// outputs of subscription_id for each subscription
output "subscription_id" {
  value       = azurerm_subscription.this
  description = "The subscription_id is the id of the newly created subscription."
}
