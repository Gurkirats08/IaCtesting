resource "azurerm_automation_account" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku
  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  tags = var.tags
}
