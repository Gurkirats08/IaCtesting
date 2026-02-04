output "id" {
  description = "The ID of the EventHub."
  value       = azurerm_eventhub.this.id
}

output "partition_ids" {
  description = "The identifiers for partitions created for Event Hubs."
  value       = azurerm_eventhub.this.partition_ids
}

output "primary_connection_string" {
  description = "The Primary Connection String for the Event Hubs authorization Rule."
  value       = { for key, value in azurerm_eventhub_authorization_rule.this : key => value.primary_connection_string }
}

output "primary_key" {
  description = "The Primary Key for the Event Hubs authorization Rule."
  value       = { for key, value in azurerm_eventhub_authorization_rule.this : key => value.primary_key }
}

output "secondary_connection_string" {
  description = "The Secondary Connection String for the Event Hubs authorization Rule."
  value       = { for key, value in azurerm_eventhub_authorization_rule.this : key => value.secondary_connection_string }
}

output "secondary_key" {
  description = "The Secondary Key for the Event Hubs authorization Rule."
  value       = { for key, value in azurerm_eventhub_authorization_rule.this : key => value.secondary_key }
}

output "consumer_group_id" {
  description = "The ID of the EventHub Consumer Group."
  value       = azurerm_eventhub_consumer_group.this.id
}
