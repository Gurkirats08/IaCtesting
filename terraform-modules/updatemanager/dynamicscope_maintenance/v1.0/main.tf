data "azurerm_maintenance_configuration" "this" {
  name                = var.maintenance_configuration_name
  resource_group_name = var.resource_group_name
}

// output "id" {
//   value = azurerm_maintenance_configuration.this.id
// }

resource "azurerm_maintenance_assignment_dynamic_scope" "this" {
  name                         = var.dynamic_scope_maintenance_name
  maintenance_configuration_id = data.azurerm_maintenance_configuration.this.id

  filter {
    locations       = ["UAE North"]
    os_types        = ["Windows"]
    resource_groups = var.resource_group_names
    resource_types  = ["Microsoft.Compute/virtualMachines"]
    tag_filter      = "Any"
    tags {
      tag    = "env"
      values = ["dev"]
    }
  }
}