### These values have to be build in local block as using data block cause terraform to process plan differently "replace" resources
locals {
  kv_crypto_user_role_id      = "12338af0-0e69-4776-bea7-57ae8d297424" # "Key Vault Crypto User"
  sa_blob_data_contributor_id = "ba92f5b4-2d11-453d-a403-e96b0029c9fe" # "Storage Blob Data Contributor"
  sub_id                      = split("/", var.user_assigned_identity_id)[2]

  key_vault_role_id       = format("/subscriptions/%s/providers/Microsoft.Authorization/roleDefinitions/%s", local.sub_id, local.kv_crypto_user_role_id)
  storage_account_role_id = format("/subscriptions/%s/providers/Microsoft.Authorization/roleDefinitions/%s", local.sub_id, local.sa_blob_data_contributor_id)
}

resource "azurerm_role_assignment" "sql_to_kv" {
  scope              = var.key_vault_id
  role_definition_id = local.key_vault_role_id
  principal_id       = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "sql_to_sa" {
  scope              = var.storage_account_id
  role_definition_id = local.storage_account_role_id
  principal_id       = var.user_assigned_identity_principal_id
}

### Original TF resource module. This doesn't allow for transparent_data_encryption to be created with the initial resource and therefore blocked by policy
# resource "azurerm_mssql_server" "this" {
#   name                = var.mssql_server_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   tags                = merge(local.tags, var.tags)
#   version             = "12.0"

#   azuread_administrator { # ASQ_IAM_001
#     login_username              = var.login_username
#     object_id                   = var.object_id
#     tenant_id                   = var.tenant_id
#     azuread_authentication_only = true
#   }

#   public_network_access_enabled        = false # ASQ_NET_003
#   outbound_network_restriction_enabled = true

#   identity {
#       type = "UserAssigned"
#       identity_ids = [ data.azurerm_user_assigned_identity.this.id ]
#   }
#   primary_user_assigned_identity_id = data.azurerm_user_assigned_identity.this.id

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# resource "azurerm_mssql_server_transparent_data_encryption" "this" { # ASQ_ENC_001
#   server_id        = azurerm_mssql_server.this.id
#   key_vault_key_id = var.key_vault_key_id # ASQ_ENC_002
# }

resource "azapi_resource" "this" {
  name      = var.mssql_server_name
  parent_id = var.resource_group_id
  location  = var.location
  type      = "Microsoft.Sql/servers@2022-05-01-preview"
  identity {
    type = "UserAssigned"
    identity_ids = [
      var.user_assigned_identity_id
    ]
  }
  body = jsonencode({
    properties = {
      keyId = var.key_vault_key_id
      administrators = {
        administratorType         = "ActiveDirectory"
        azureADOnlyAuthentication = true
        login                     = var.login_username
        sid                       = var.object_id
        tenantId                  = var.tenant_id
      }
      minimalTlsVersion             = "1.2"
      primaryUserAssignedIdentityId = var.user_assigned_identity_id
      publicNetworkAccess           = "Disabled"
      version                       = "12.0"
    }
  })
  depends_on = [
    azurerm_role_assignment.sql_to_kv
  ]
}

// have to re-enable this after creating the blob for audit logs

# resource "azurerm_mssql_server_extended_auditing_policy" "this" { # ASQ_LOG_001
#   server_id         = azapi_resource.this.id
#   storage_endpoint  = var.blob_endpoint
#   retention_in_days = 90
#   depends_on = [
#     azurerm_role_assignment.sql_to_sa
#   ]
# }

# resource "azurerm_mssql_server_microsoft_support_auditing_policy" "this" { # ASQ_LOG_001
#   server_id             = azapi_resource.this.id
#   blob_storage_endpoint = var.blob_endpoint
#   depends_on = [
#     azurerm_role_assignment.sql_to_sa
#   ]
# }
