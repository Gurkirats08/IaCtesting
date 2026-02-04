data "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = var.backupvaultname
  resource_group_name = var.resource_group_name
}

resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "policy" {
  name                = var.backup_policy_name
  resource_group_name = var.resource_group_name
  vault_name          = data.azurerm_data_protection_backup_vault.backup_vault.name

  backup_repeating_time_intervals = ["R/2024-04-14T06:33:16+00:00/PT4H"]
  default_retention_rule {
    life_cycle {
      duration        = "P7D"
      data_store_type = "OperationalStore"
    }
  }

}

#------------------------------------AKS Backup Policy Instance Creation------------------------------------#

data "azurerm_storage_account" "stg" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_rg
}

data "azurerm_kubernetes_cluster" "akscluster" {
  name                = var.akscluster_name
  resource_group_name = var.aks_cluster_rg
}

#Create a Trusted Access Role Binding between AKS Cluster and Backup Vault
resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "trustedaccess" {
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.akscluster.id
  name                  = var.cluster_access_name
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = data.azurerm_data_protection_backup_vault.backup_vault.id

}

#Create a Blob Container where backup items will stored
resource "azurerm_storage_container" "backupcontainer" {
  name                  = var.stg_container_name
  storage_account_name  = data.azurerm_storage_account.stg.name
  container_access_type = "private"
}

#Create Backup Extension in AKS Cluster
resource "azurerm_kubernetes_cluster_extension" "dataprotection" {
  name           = var.backup_extension_name
  cluster_id     = data.azurerm_kubernetes_cluster.akscluster.id
  extension_type = "Microsoft.DataProtection.Kubernetes"
  configuration_settings = {
    "configuration.backupStorageLocation.bucket"                   = azurerm_storage_container.backupcontainer.name
    "configuration.backupStorageLocation.config.storageAccount"    = data.azurerm_storage_account.stg.name
    "configuration.backupStorageLocation.config.resourceGroup"     = data.azurerm_storage_account.stg.resource_group_name
    "configuration.backupStorageLocation.config.subscriptionId"    = var.subscriptionId
    "credentials.tenantId"                                         = var.tenantId
    "configuration.backupStorageLocation.config.useAAD"            = true
    "configuration.backupStorageLocation.config.storageAccountURI" = data.azurerm_storage_account.stg.primary_blob_endpoint
  }
  depends_on = [azurerm_storage_container.backupcontainer]
}

#Assign Role to Extension Identity over Storage Account
resource "azurerm_role_assignment" "extensionrole" {
  scope                = data.azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id
  depends_on           = [azurerm_kubernetes_cluster_extension.dataprotection]
}

#Assign Role to Backup Vault over AKS Cluster
resource "azurerm_role_assignment" "vault_msi_read_on_cluster" {
  scope                = data.azurerm_kubernetes_cluster.akscluster.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id
}

#Assign Role to Backup Vault over Snapshot Resource Group
resource "azurerm_role_assignment" "vault_msi_read_on_snap_rg" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_data_protection_backup_vault.backup_vault.identity[0].principal_id

}

#Assign Role to AKS Cluster over Snapshot Resource Group
resource "azurerm_role_assignment" "cluster_msi_contributor_on_snap_rg" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = var.managed_identity_principal_id

}

#Create Backup Instance for AKS Cluster
resource "azurerm_data_protection_backup_instance_kubernetes_cluster" "akstfbi" {
  name                         = var.cluster_instance_name
  location                     = var.location
  vault_id                     = data.azurerm_data_protection_backup_vault.backup_vault.id
  kubernetes_cluster_id        = data.azurerm_kubernetes_cluster.akscluster.id
  snapshot_resource_group_name = var.resource_group_name
  backup_policy_id             = azurerm_data_protection_backup_policy_kubernetes_cluster.policy.id

  backup_datasource_parameters {
    excluded_namespaces              = []
    excluded_resource_types          = []
    cluster_scoped_resources_enabled = true
    included_namespaces              = []
    included_resource_types          = []
    label_selectors                  = []
    volume_snapshot_enabled          = true
  }

  depends_on = [
    azurerm_data_protection_backup_policy_kubernetes_cluster.policy,
    azurerm_role_assignment.extensionrole,
    azurerm_role_assignment.vault_msi_read_on_cluster,
    azurerm_role_assignment.vault_msi_read_on_snap_rg,
    azurerm_role_assignment.cluster_msi_contributor_on_snap_rg
  ]
}


