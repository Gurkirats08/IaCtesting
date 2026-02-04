terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_keys_on_destroy = false
    }
  }

  skip_provider_registration = false
}

data "azuread_client_config" "current" {}

data "azurerm_storage_account" "this" {
  resource_group_name = split("/", var.storage_account_id)[4]
  name                = split("/", var.storage_account_id)[8]
}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.5"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  generator = {
    plz = {
      random                 = 1
      sql_server             = 1
      storage_account        = 1
      user_assigned_identity = 1
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.plz.random[0]
  location            = module.naming.location
}

resource "azurerm_user_assigned_identity" "this" {
  location            = module.naming.location
  name                = module.naming.generated_names.plz.user_assigned_identity[0]
  resource_group_name = module.resource_group.name
}

module "key_vault_key" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault-key?ref=1.0.1"
  name         = format("%s-transparent-data-encryption-key-%s", module.naming.generated_names.plz.sql_server[0], split("-", module.naming.generated_names.plz.random[0])[3])
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = "3072"

  key_opts = [
    "unwrapKey",
    "wrapKey",
  ]
}

module "mssql_server" {
  source                              = "../."
  mssql_server_name                   = module.naming.generated_names.plz.sql_server[0]
  resource_group_id                   = module.resource_group.id
  location                            = module.naming.location
  key_vault_id                        = var.key_vault_id
  login_username                      = "AzureAD Admin"
  object_id                           = data.azuread_client_config.current.object_id
  tenant_id                           = data.azuread_client_config.current.tenant_id
  key_vault_key_id                    = module.key_vault_key.id
  storage_account_id                  = var.storage_account_id
  blob_endpoint                       = data.azurerm_storage_account.this.primary_blob_endpoint
  user_assigned_identity_id           = azurerm_user_assigned_identity.this.id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.this.principal_id
}
