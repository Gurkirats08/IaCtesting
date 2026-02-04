# -
# - Bastion Host
# -
resource "azurerm_bastion_host" "main" {
  for_each            = var.bastion_hosts
  name                = each.value.bastionName
  resource_group_name = var.resourceGroupName
  location            = var.main_location
  sku                 = each.value.bastion_sku
  ip_configuration {
    name                 = "${each.value.VirtualNetworkName}-${each.value.bastionName}-IPConfig"
    subnet_id            = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.subnetRG}/providers/Microsoft.Network/virtualNetworks/${each.value.VirtualNetworkName}/subnets/AzureBastionSubnet"
    public_ip_address_id = "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/${each.value.bastionIPName}"
  }

}
