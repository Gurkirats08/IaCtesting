resource "azurerm_recovery_services_vault" "this" {
  name                               = var.recovery_services_vault_name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  sku                                = var.sku
  tags                               = var.tags
  public_network_access_enabled      = var.public_network_access_enabled
  soft_delete_enabled                = var.soft_delete_enabled
  storage_mode_type                  = var.storage_mode_type
  cross_region_restore_enabled       = var.cross_region_restore_enabled
  classic_vmware_replication_enabled = var.classic_vmware_replication_enabled
  immutability                       = "Locked"

  # encryption {
  #   key_id                            = var.encryption_key_id
  #   infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  #   user_assigned_identity_id         = var.user_assigned_identity_id
  #   use_system_assigned_identity      = var.use_system_assigned_identity
  # }

  monitoring {
    alerts_for_all_job_failures_enabled            = var.alerts_for_all_job_failures_enabled
    alerts_for_critical_operation_failures_enabled = var.alerts_for_critical_operation_failures_enabled
  }
  identity {
    type         = var.identity_type
    identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type) ? var.identity_ids : []
  }
  lifecycle {
    ignore_changes = [identity, encryption]
  }
}
