data "azurerm_recovery_services_vault" "rsv" {
  name                = var.recovery_vault_name
  resource_group_name = var.rsv_resource_group_name
}

resource "azurerm_backup_policy_vm" "example" {
  name                = var.backup_policy_name
  resource_group_name = data.azurerm_recovery_services_vault.rsv.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.rsv.name
  policy_type         = "V2"

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.retention_daily_count
  }
}

data "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.vm_resource_group_name
}

resource "azurerm_backup_protected_vm" "vm1" {
  resource_group_name = data.azurerm_recovery_services_vault.rsv.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.rsv.name
  source_vm_id        = data.azurerm_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.example.id
}
