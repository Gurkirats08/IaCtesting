data "azurerm_client_config" "current" {}

# Multiple Resource Group
module "resource_group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules\\resourcegroup\\v1.0"
  location            = each.value.location
  resource_group_name = each.value.name
  tags                = each.value.tags
}

#----------------------------------------------------------------
#Network resources in Network RG 

# mgmt NSGs
module "mgmt_nsg_module" {
  source                  = "..\\..\\terraform-modules\\networksecuritygroup\\v1.0"
  main_location           = var.mainLocation
  environment             = var.environment
  network_security_groups = var.mgmtNetworkSecurityGroups
  depends_on = [ module.resource_group]
}

# mgmt virtual networks
module "mgmt_vnet_module" {
  for_each                     = var.mgmtVirtualNetworks
  source                       = "..\\..\\terraform-modules\\virtualnetwork\\v1.0"
  virtual_network_name         = each.value.VirtualNetworkName
  resource_group_name          = each.value.resourceGroupName
  location                     = var.mainLocation
  address_space                = [each.value.address_space]
  tags                         = { "environment" : var.environment }
  depends_on                   = [module.resource_group]
}

# mgmt subnets
module "mgmt_subnet_module" {
  for_each                          = var.mgmtSubnets
  source                            = "..\\..\\terraform-modules\\subnet\\v1.0"
  resource_group_name               = each.value.resourceGroupName
  virtual_network_name              = each.value.vnet_name
  subnet_name                       = each.value.name
  address_prefixes                  = [each.value.addressPrefix]
  route_table_id                    = each.value.rtName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/routeTables/${each.value.rtName}" #each.value.routeTableId
  private_endpoint_network_policies = var.private_endpoint_network_policies
  network_security_group_id         = each.value.nsgName == null ? null : "/subscriptions/${each.value.subscriptionId}/resourceGroups/${var.resourceGroups["netRG"].name}/providers/Microsoft.Network/networkSecurityGroups/${each.value.nsgName}"
  depends_on                        = [module.resource_group, module.mgmt_vnet_module, module.mgmt_nsg_module, module.mgmt_route_table_module]
}

# route table mgmt
module "mgmt_route_table_module" {
  for_each            = var.mgmtRouteTables
  source              = "..\\..\\terraform-modules\\routetable\\v1.0"
  resource_group_name = each.value.resourceGroupName
  route_table_name    = each.value.routeTableName
  location            = var.mainLocation
  tags                = { "environment" : var.environment }
  route_table = {
    bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
    routes                        = each.value.routes
  }
  depends_on = [module.resource_group]
}


# mgmt user assigned identity
module "mgmt_user_assigned_identity" {
  source              = "..\\..\\terraform-modules\\userassignedidentity\\v1.0"
  for_each            = var.userAssignedIdentityName
  name                = each.value.uai_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  depends_on          = [module.resource_group, module.mgmt_route_table_module]
}

# # mgmt Storage Account
module "mgmt_storage_account" {
  for_each                        = var.mgmtStorageAccounts
  source                          = "..\\..\\terraform-modules\\storageaccount\\v1.0"
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  name                            = each.value.name
  user_assigned_identity_id       = module.mgmt_user_assigned_identity["uai1"].id
  identity_type                   = "UserAssigned"
  identity_ids                    = [module.mgmt_user_assigned_identity["uai1"].id]
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  queue_encryption_key_type       = "Account"
  table_encryption_key_type       = "Account"
  depends_on                      = [module.resource_group, module.mgmt_user_assigned_identity]
}

# referring the auto created network watcher
data "azurerm_network_watcher" "mgmt_network_watcher" {
  name                = var.network_watcher_name
  resource_group_name = var.network_watcher_rg
}




