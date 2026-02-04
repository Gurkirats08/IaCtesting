resource "azurerm_private_endpoint" "this" {
  name                          = var.private_endpoint_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.subnet_id
  custom_network_interface_name = format("%s-%s", var.private_endpoint_name, "nic")
  private_dns_zone_group {
    name                 = format("%s-%s", var.private_endpoint_name, "pdz")
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
  private_service_connection {
    name                           = format("%s-%s", var.private_endpoint_name, "psc")
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
}

