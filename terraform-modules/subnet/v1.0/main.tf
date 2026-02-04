resource "azurerm_subnet" "this" {
  name                                          = var.subnet_name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = var.address_prefixes
  service_endpoints                             = var.service_endpoints == null ? [] : var.service_endpoints
#  private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled #for provider version < 4.0
  private_endpoint_network_policies = var.private_endpoint_network_policies #provider version > 4.x
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = var.delegation_name == null ? [] : [var.delegation_name]
    content {
      name = var.delegation_name
      service_delegation {
        name    = var.service_delegation_name
        actions = var.service_delegation_actions
      }
    }
  }
}


# associate the subnet created with the given NSG
resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = var.network_security_group_id != null ? 1 : 0
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = var.network_security_group_id
  depends_on                = [azurerm_subnet.this]
}

# associate the subnet created with the given route-table
resource "azurerm_subnet_route_table_association" "this" {
  count          = var.route_table_id != null ? 1 : 0
  subnet_id      = azurerm_subnet.this.id
  route_table_id = var.route_table_id
  depends_on     = [azurerm_subnet.this]
}
