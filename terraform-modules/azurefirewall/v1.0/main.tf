# data "azurerm_resource_group" "this" {
#   for_each = local.resourcegroup_state_exists == false ? var.firewalls : {}
#   name     = each.value.resourceGroupName
# }

locals {
  resourcegroup_state_exists = false
}
resource "azurerm_firewall" "this" {
  for_each            = var.firewalls
  name                = each.value["firewallName"]
  location            = var.location
  resource_group_name = var.resource_group_name
  firewall_policy_id  = var.firewall_policy_ids[each.value.firewallName].id
  threat_intel_mode   = lookup(each.value, "threatIntelMode", null)
  sku_name            = lookup(each.value, "vNetName", null) == null ? "AZFW_Hub" : "AZFW_VNet"
  sku_tier            = each.value.firewallSkuTier

  ip_configuration {
    name                 = each.value.firewallIPName
    subnet_id            = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${each.value.resourceGroupName}/providers/Microsoft.Network/virtualNetworks/${each.value.vNetName}/subnets/AzureFirewallSubnet"
    public_ip_address_id = var.firewall_ip_ids[each.value.firewallName].id
  }
}

# Firewall Network Rules
resource "azurerm_firewall_network_rule_collection" "this" {
  for_each            = var.fw_network_rules
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this[each.value.firewall_key].name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}

# Firewall NAT Rules
resource "azurerm_firewall_nat_rule_collection" "this" {
  for_each            = var.fw_nat_rules
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this[each.value.firewall_key].name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = "Dnat"

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}

# Firewall Application Rules
resource "azurerm_firewall_application_rule_collection" "this" {
  for_each            = var.fw_application_rules
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this[each.value.firewall_key].name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      description      = rule.value.description
      source_addresses = rule.value.source_addresses
      fqdn_tags        = rule.value.fqdn_tags
      target_fqdns     = rule.value.target_fqdns

      dynamic "protocol" {
        for_each = rule.value.protocol
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}
