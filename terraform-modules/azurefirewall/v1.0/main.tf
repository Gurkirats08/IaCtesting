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
