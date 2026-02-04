# #############################################################################
# # OUTPUTS Log Analytics Workspace
# #############################################################################

output "law_workspace" {
  description = ""
  value       = azurerm_log_analytics_workspace.this
  sensitive   = true
}

output "law_id" {
  description = ""
  value       = [for x in azurerm_log_analytics_workspace.this : x.id]
}

output "law_name" {
  description = ""
  value       = [for x in azurerm_log_analytics_workspace.this : x.name]
}

output "law_key" {
  description = ""
  value       = [for x in azurerm_log_analytics_workspace.this : x.primary_shared_key]
  sensitive   = true
}

# output "law_workspace_id" {
#   description = ""
#   value       = [for x in azurerm_log_analytics_workspace.this : x.workspace_id]
# }

output "law_workspace_ids" {
  description = "The resource IDs of the Log Analytics workspaces."
  value       = [for x in azurerm_log_analytics_workspace.this : x.id]
}

output "law_id_map" {
  value = {
    #for x in azurerm_log_analytics_workspace.this : x.name => x.id
    for x in azurerm_log_analytics_workspace.this : x.name => x.id
  }
}
