output "virtual_hub_id" {
  value = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets ? azurerm_virtual_hub.azurerm_virtual_hub[0].id : 0
}

output "virtual_hub_name" {
  value = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets ? azurerm_virtual_hub.azurerm_virtual_hub[0].name : 0
}

