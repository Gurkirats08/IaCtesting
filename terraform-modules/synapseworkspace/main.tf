resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = "${var.synapse_workspace_name}filesystem"
  storage_account_id = var.storage_account_id

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_synapse_workspace" "this" {
  name                                 = var.synapse_workspace_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this.id

  aad_admin {
    login     = var.aad_login
    object_id = var.aad_object_id
    tenant_id = var.aad_tenant_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
