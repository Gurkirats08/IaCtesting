resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.acr_rg
  location                      = var.acr_location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  trust_policy_enabled          = var.trust_policy_enabled
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  retention_policy_in_days      = var.sku == "Premium" ? var.retention_policy_in_days : 0
  export_policy_enabled         = var.export_policy_enabled
  data_endpoint_enabled         = var.data_endpoint_enabled
  anonymous_pull_enabled        = var.anonymous_pull_enabled
  quarantine_policy_enabled     = var.quarantine_policy_enabled


  # Identity Block
  identity {
    type         = var.identity
    identity_ids = var.identity == "UserAssigned" ? [var.identity_id] : null
  }

  #  Geo-replication Block
  dynamic georeplications {
      for_each = var.sku == "Premium" ? [1] : []
      content {
      location                = var.acr_location
      zone_redundancy_enabled = var.zone_redundancy_enabled
    } 
  }
}
