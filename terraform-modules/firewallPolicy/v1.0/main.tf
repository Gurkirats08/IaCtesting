data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.firewall_policy : {}
  name     = each.value.resourceGroupName
}

locals {
  resourcegroup_state_exists = false
}

resource "azurerm_firewall_policy" "this" {
  for_each                 = var.firewall_policy
  name                     = each.key
  resource_group_name      = each.value.resourceGroupName
  sku                      = each.value.firewallPolicyTier
  location                 = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  threat_intelligence_mode = each.value.threatIntelMode
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  for_each = merge([
    for firewall in var.firewall_policy :
    { for ruleCollectionGroup in firewall.firewallPolicyRuleCollectionGroups :
      "${firewall.firewallName}__${ruleCollectionGroup.name}" => {
        fireWallName    = firewall.firewallName
        name            = ruleCollectionGroup.name
        priority        = ruleCollectionGroup.priority
        ruleCollections = ruleCollectionGroup.ruleCollections
      }
    }
  ]...)
  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.this[each.value.fireWallName].id
  priority           = each.value.priority

  dynamic "application_rule_collection" {
    for_each = each.value.ruleCollections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action.type
      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name                  = rule.value.name
          source_addresses      = lookup(rule.value, "sourceAddresses", null)
          destination_addresses = lookup(rule.value, "destinationAdresses", null)
          destination_fqdns     = lookup(rule.value, "targetFqdns", null)
          terminate_tls         = lookup(rule.value, "terminateTLS", null)
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              port = protocols.value.port
              type = protocols.value.protocolType
            }
          }
        }
      }
    }
  }
  depends_on = [azurerm_firewall_policy.this]
}
