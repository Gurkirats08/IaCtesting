resource "random_id" "this" {
  for_each    = var.workspaces
  byte_length = 5
  keepers = {
    rg = each.value.resourceGroupName
  }
}

locals {
  resourcegroup_state_exists = false
  keyvault_state_exists      = false

  log_analytics_names = {
    for workspace_key, workspace_value in var.workspaces : workspace_key => workspace_value.name != null ? workspace_value.name : substr("log-anaylytics-name-${random_id.this[workspace_key].hex}", 0, 23)
  }
  #name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
}

# -
# - Create Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "this" {
  for_each                   = var.workspaces
  name                       = local.log_analytics_names[each.key]
  resource_group_name        = each.value.resourceGroupName
  location                   = var.location
  sku                        = lookup(each.value, "sku", null)
  retention_in_days          = lookup(each.value, "retentionPeriod", null)
  internet_ingestion_enabled = lookup(each.value, "internetIngestionEnabled", null)
  internet_query_enabled     = lookup(each.value, "internetQueryEnabled", null)
  daily_quota_gb             = lookup(each.value, "dailyQuotaGb", null)

  tags = var.tags
}

# -
# - Install the VMInsights solution
# -
# resource "azurerm_log_analytics_solution" "this" {
#   solution_name         = "VMInsights"
#   location              = data.azurerm_resource_group.this.location
#   resource_group_name   = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.name
#   workspace_resource_id = azurerm_log_analytics_workspace.this.id
#   workspace_name        = azurerm_log_analytics_workspace.this.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/VMInsights"
#   }
# }

# -	
# - Store LAW Workspace Id and Primary Key to Key Vault Secrets	
# -	
# locals {
#   log_analytics_workspace = {
#     law-primary-shared-key = azurerm_log_analytics_workspace.this.primary_shared_key
#     law-workspace-id       = azurerm_log_analytics_workspace.this.workspace_id
#     law-resource-id        = azurerm_log_analytics_workspace.this.id
#   }
# }

# resource "azurerm_key_vault_secret" "this" {
#   for_each        = local.log_analytics_workspace
#   name            = each.key
#   value           = each.value
#   key_vault_id    = data.azurerm_key_vault.this.id
#   expiration_date = null #timeadd(formatdate("YYYY-MM-DD'T'00:00:00Z", timestamp()), "2191h")
#   depends_on      = [azurerm_log_analytics_workspace.this]
# }
