resource "azurerm_data_protection_backup_vault" "this" {
  name                = var.backupvaultname
  resource_group_name = var.resource_group_name
  location            = var.location

  # Specify the type of the data store
  datastore_type = var.datastore_type

  # Define the redundancy type
  redundancy  = var.redundancy
  soft_delete = "Off"



  identity {
    type = "SystemAssigned"
  }
}
