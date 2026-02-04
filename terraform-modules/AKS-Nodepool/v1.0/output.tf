output "azurerm_kubernetes_cluster_node_pool" {
  description = "The ID of aks cluster"
  value       = azurerm_kubernetes_cluster_node_pool.nodepool.id
}