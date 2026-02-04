resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  #provider              = azurerm.conn_subscription_id
  name                  = var.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.registration_enabled
}