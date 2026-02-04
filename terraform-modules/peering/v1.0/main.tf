# terraform {
#   required_providers {
#     azurerm = {
#       source                = "hashicorp/azurerm"
#       version               = "~> 3.78.0"
#       configuration_aliases = [azurerm.source, azurerm.destination]
#     }
#   }
# }

data "azurerm_virtual_network" "source" {
  provider            = azurerm.source
  name                = var.sourceVnetName
  resource_group_name = var.sourceVnetRg
}

data "azurerm_virtual_network" "destination" {
  provider            = azurerm.dest
  name                = var.destinationVnetName
  resource_group_name = var.destinationVnetRg
}

resource "azurerm_virtual_network_peering" "source_to_destination" {
  provider                     = azurerm.source
  name                         = "${var.sourceVnetName}-to-${var.destinationVnetName}"
  remote_virtual_network_id    = var.remote_virtual_network_id != null ? var.remote_virtual_network_id : data.azurerm_virtual_network.destination.id
  resource_group_name          = var.sourceVnetRg
  virtual_network_name         = var.sourceVnetName
  allow_forwarded_traffic      = coalesce(var.allowForwardedTraffic, true)
  allow_virtual_network_access = coalesce(var.allowVirtualNetworkAccess, true)
  allow_gateway_transit        = coalesce(var.allowGatewayTransit, false)
  use_remote_gateways          = coalesce(var.useRemoteGateways, false)

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  provider                     = azurerm.dest
  name                         = "${var.destinationVnetName}-to-${var.sourceVnetName}"
  remote_virtual_network_id    = var.remote_virtual_network_id != null ? var.remote_virtual_network_id : data.azurerm_virtual_network.source.id
  resource_group_name          = var.destinationVnetRg
  virtual_network_name         = var.destinationVnetName
  allow_forwarded_traffic      = coalesce(var.allowForwardedTraffic, true)
  allow_virtual_network_access = coalesce(var.allowVirtualNetworkAccess, true)
  allow_gateway_transit        = coalesce(var.allowGatewayTransit, false)
  use_remote_gateways          = coalesce(var.useRemoteGateways, false)
}
