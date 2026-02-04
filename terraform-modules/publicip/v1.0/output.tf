# #############################################################################
# # OUTPUTS IPs
# #############################################################################

output "public_ip_ids" {
  value = azurerm_public_ip.this
}


output "bastion_ip_names" {
  value = { for k, v in azurerm_public_ip.this : k => v.name if contains(keys(var.public_IPs), k) }
}
