data "azurerm_virtual_machine" "this" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
}

locals {
  resourcegroup_state_exists = false
}

# -
# - Create VM Extensions
# -
resource "azurerm_virtual_machine_extension" "this" {
  name                       = var.name
  virtual_machine_id         = data.azurerm_virtual_machine.this.id
  publisher                  = var.publisher
  type                       = var.type
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version
  automatic_upgrade_enabled  = var.automatic_upgrade_enabled
  settings                   = var.settings
  protected_settings         = var.protected_settings
  lifecycle {
    ignore_changes = [ virtual_machine_id ] 
  }
}
