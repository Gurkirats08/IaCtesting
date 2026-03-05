# #############################################################################
# # OUTPUTS Azure Firewall
# #############################################################################

output "firewall_ids" {
  value = [for x in azurerm_firewall.this : x.id]
}

# output "firewall_public_ips" {
#   value = [for x in azurerm_public_ip.this : x.ip_address]
# }

output "firewall_names" {
  value = [for x in azurerm_firewall.this : x.name]
}

output "firewall_private_ips" {
  value = [for x in azurerm_firewall.this : x.ip_configuration.*.private_ip_address]
}

output "firewall_ips_map" {
  value = {
    for x in azurerm_firewall.this : x.name => x.ip_configuration.0.private_ip_address
  }
}

# Firewall Rule Collection Outputs
output "network_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_network_rule_collection.this : k => v.id
  }
  description = "IDs of the firewall network rule collections"
}

output "nat_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_nat_rule_collection.this : k => v.id
  }
  description = "IDs of the firewall NAT rule collections"
}

output "application_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_application_rule_collection.this : k => v.id
  }
  description = "IDs of the firewall application rule collections"
}