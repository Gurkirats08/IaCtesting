output "ddos_protection_plan_ids" {
  value       = { for p in azurerm_network_ddos_protection_plan.this : p.name => p.id }
  description = "Map of DDoS Protection Plan names to their IDs."
}
 
