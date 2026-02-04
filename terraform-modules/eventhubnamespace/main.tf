locals {
  key_expiration_date = (
    var.key_expiration_date == null ? time_rotating.this.rotation_rfc3339 : var.key_expiration_date
  )
}

resource "time_rotating" "this" {
  rotation_months = 12
}

resource "azurerm_eventhub_namespace" "this" {
  name                          = var.azurerm_eventhub_namespace_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium" # Hardcoded as only Premium SKU supports CMK.
  zone_redundant                = var.zone_redundant
  capacity                      = var.capacity
  local_authentication_enabled  = var.local_authentication_enabled  # AEH_IAM_005
  public_network_access_enabled = var.public_network_access_enabled # AEH_NET_001
  minimum_tls_version           = "1.2"
  tags                          = merge(local.tags, var.tags)

  identity {
    type = "SystemAssigned"
  }

  # AEH_NET_001
  dynamic "network_rulesets" {
    for_each = try(var.network_rulesets, null) != null ? [var.network_rulesets] : []
    content {
      default_action                 = network_rulesets.value.default_action
      trusted_service_access_enabled = network_rulesets.value.trusted_service_access_enabled
      public_network_access_enabled  = network_rulesets.value.public_network_access_enabled

      dynamic "virtual_network_rule" {
        for_each = try(network_rulesets.value.virtual_network_rule, null) != null ? [network_rulesets.value.virtual_network_rule] : []
        content {
          subnet_id                                       = virtual_network_rule.value.subnet_id
          ignore_missing_virtual_network_service_endpoint = lookup(virtual_network_rule.value, "ignore_missing_virtual_network_service_endpoint", null)
        }
      }

      dynamic "ip_rule" {
        for_each = try(network_rulesets.value.ip_rule, null) != null ? network_rulesets.value.ip_rule : []
        content {
          ip_mask = ip_rule.value.ip_mask
          action  = lookup(ip_rule.value, "action", null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_role_assignment" "this" {
  scope                = var.key_vault_id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_eventhub_namespace.this.identity[0].principal_id
  depends_on           = [azurerm_eventhub_namespace.this]
}

# Add key-vault access policy for the particular namespace managed identity
# resource "azurerm_key_vault_access_policy" "this" {
#   key_vault_id = var.key_vault_id
#   tenant_id    = azurerm_eventhub_namespace.this.identity.0.tenant_id
#   object_id    = azurerm_eventhub_namespace.this.identity.0.principal_id

#   key_permissions = ["Get", "UnwrapKey", "WrapKey"]
# }

resource "azurerm_key_vault_key" "this" {
  name            = format("%s-key", azurerm_eventhub_namespace.this.name)
  key_vault_id    = var.key_vault_id
  key_type        = var.key_type
  key_size        = var.key_size
  expiration_date = local.key_expiration_date

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]
  depends_on = [azurerm_eventhub_namespace.this, azurerm_role_assignment.this]
}

# AEH_ENC_001
resource "azurerm_eventhub_namespace_customer_managed_key" "this" {
  eventhub_namespace_id = azurerm_eventhub_namespace.this.id
  key_vault_key_ids     = [azurerm_key_vault_key.this.id]
  depends_on            = [azurerm_key_vault_key.this]
}
