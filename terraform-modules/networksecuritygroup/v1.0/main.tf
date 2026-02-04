data "azurerm_resource_group" "this" {
  for_each = local.resourcegroup_state_exists == false ? var.network_security_groups : {}
  name     = each.value.resourceGroupName
}

data "azurerm_application_security_group" "src" {
  for_each            = local.asg_state_exists == false ? { for asg in local.source_asg_names : asg.key => asg.name } : {}
  name                = each.value
  resource_group_name = var.resource_group_name
}

data "azurerm_application_security_group" "dest" {
  for_each            = local.asg_state_exists == false ? { for asg in local.destination_asg_names : asg.key => asg.name } : {}
  name                = each.value
  resource_group_name = var.resource_group_name
}

locals {
  tags                       = merge(var.nsg_additional_tags, merge([for rg in data.azurerm_resource_group.this : rg.tags]...))
  resourcegroup_state_exists = false
  networking_state_exists    = false
  asg_state_exists           = false

  source_asg_names = flatten([
    for k, v in var.network_security_groups : [
      for rule in coalesce(v.securityRules, []) : [
        for asg in coalesce(rule.properties.sourceApplicationSecurityGroupNames, []) : {
          key  = format("%s_%s_%s", k, rule.name, asg)
          name = asg
        }
      ]
    ]
  ])

  destination_asg_names = flatten([
    for k, v in var.network_security_groups : [
      for rule in coalesce(v.securityRules, []) : [
        for asg in coalesce(rule.properties.destinationApplicationSecurityGroupNames, []) : {
          key  = format("%s_%s_%s", k, rule.name, asg)
          name = asg
        }
      ]
    ]
  ])
}

# -
# - Network Security Group
# -
resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = var.main_location != null ? var.main_location : data.azurerm_resource_group.this[each.key].location
  resource_group_name = each.value["resourceGroupName"]

  dynamic "security_rule" {
    for_each = lookup(each.value, "securityRules", [])
    content {
      name                                       = security_rule.value["name"]
      description                                = lookup(security_rule.value, "description", null)
      protocol                                   = coalesce(security_rule.value.properties["protocol"], "Tcp")
      direction                                  = security_rule.value.properties["direction"]
      access                                     = coalesce(security_rule.value.properties["access"], "Allow")
      priority                                   = security_rule.value.properties["priority"]
      source_address_prefix                      = lookup(security_rule.value.properties, "sourceAddressPrefix", null)
      source_address_prefixes                    = lookup(security_rule.value.properties, "sourceAddressPrefixes", null)
      destination_address_prefix                 = lookup(security_rule.value.properties, "destinationAddressPrefix", null)
      destination_address_prefixes               = lookup(security_rule.value.properties, "destinationAddressPrefixes", null)
      source_port_range                          = lookup(security_rule.value.properties, "sourcePortRange", null)
      source_port_ranges                         = lookup(security_rule.value.properties, "sourcePortRanges", null)
      destination_port_range                     = lookup(security_rule.value.properties, "destinationPortRange", null)
      destination_port_ranges                    = lookup(security_rule.value.properties, "destinationPortRanges", null)
      source_application_security_group_ids      = lookup(security_rule.value.properties, "sourceApplicationSecurityGroupNames", null) != null ? [for asg_name in security_rule.value.source_application_security_group_names : (local.asg_state_exists == true ? asg_name : lookup(data.azurerm_application_security_group.src, "${each.key}_${security_rule.value.name}_${asg_name}")["id"])] : null
      destination_application_security_group_ids = lookup(security_rule.value.properties, "destinationApplicationSecurityGroupNames", null) != null ? [for asg_name in security_rule.value.destination_application_security_group_names : (local.asg_state_exists == true ? asg_name : lookup(data.azurerm_application_security_group.dest, "${each.key}_${security_rule.value.name}_${asg_name}")["id"])] : null
    }
  }

  tags = { environment : var.environment }
}

module "diagnostics_log" {
  source                     = "../../diagnosticlogs"
  for_each                   = var.enable_diagnostic_log ? var.network_security_groups : {}
  name                       = format("%s-%s", azurerm_network_security_group.this[each.key].name, "diagnostic-settings")
  target_resource_id         = azurerm_network_security_group.this[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_resourceid
  depends_on                 = [azurerm_network_security_group.this]
}

resource "azurerm_network_watcher_flow_log" "this" {
  for_each                  = var.enable_flow_log ? var.network_security_groups : {}
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.resource_group_name
  name                      = format("%s-%s", each.value["name"], "log")
  network_security_group_id = azurerm_network_security_group.this[each.key].id
  storage_account_id        = var.flowlog_storage_resourceid
  enabled                   = true
  retention_policy {
    enabled = true
    days    = 100
  }
  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.main_location
    workspace_resource_id = var.log_analytics_workspace_resourceid
    interval_in_minutes   = 10
  }
  depends_on = [azurerm_network_security_group.this]
}
