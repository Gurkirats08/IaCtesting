data "azurerm_maintenance_configuration" "this" {
  name                = var.maintenance_configuration_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_maintenance_assignment_virtual_machine" "this" {
  location                     = var.location
  maintenance_configuration_id = data.azurerm_maintenance_configuration.this.id
  virtual_machine_id           = var.virtual_machine_id
}
