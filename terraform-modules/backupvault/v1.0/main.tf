resource "azurerm_data_protection_backup_vault" "this" {
  name                = var.backupvaultname
  resource_group_name = var.resource_group_name
  location            = var.location

  # Specify the type of the data store
  datastore_type      = var.datastore_type

  # Define the redundancy type
  redundancy          = var.redundancy

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_protection_backup_policy_blob_storage" "policy" {
  name       = var.backuppolicy
  vault_id   = azurerm_data_protection_backup_vault.this.id

  retention_rule {
    name     = "Default"
    priority = 1
    
    life_cycle {
      duration        = var.retention_duration
      data_store_type = "OperationalStore"
    }
    
    criteria {
      absolute_criteria = "AllBackup"
    }
  }
}