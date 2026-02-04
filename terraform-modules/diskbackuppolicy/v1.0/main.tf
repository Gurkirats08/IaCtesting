data "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = var.backupvaultname
  resource_group_name = var.backupvault_resource_group_name
}

data "azurerm_managed_disk" "existing" {
  name                = var.managed_disk_name
  resource_group_name = var.managed_disk_resource_group_name
}

data "azurerm_resource_group" "snapshot_resource_group" {
  name     = var.snapshot_resource_group_name
}

resource "azurerm_data_protection_backup_policy_disk" "example" {
  name     = var.backup_policy_name
  vault_id = var.backup_vault_id

  backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
  default_retention_duration      = "P7D"
  time_zone                       = "W. Europe Standard Time"

  retention_rule {
    name     = "Daily"
    duration = "P7D"
    priority = 25
    criteria {
      absolute_criteria = "FirstOfDay"
    }
  }

  retention_rule {
    name     = "Weekly"
    duration = "P7D"
    priority = 20
    criteria {
      absolute_criteria = "FirstOfWeek"
    }
  }
}

resource "azurerm_role_assignment" "role1" {
  scope                = data.azurerm_resource_group.snapshot_resource_group.id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "role2" {
  scope                = data.azurerm_managed_disk.existing.id
  role_definition_name = "Disk Backup Reader"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_instance_disk" "example" {
  name                         = var.backup_instance_name
  vault_id                     = var.backup_vault_id
  location                     = var.location
  disk_id                      = data.azurerm_managed_disk.existing.id
  snapshot_resource_group_name = var.snapshot_resource_group_name
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.example.id
  depends_on                   = [azurerm_data_protection_backup_policy_disk.example, azurerm_role_assignment.role1, azurerm_role_assignment.role2]
}
