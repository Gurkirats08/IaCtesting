terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.9"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy          = false
      purge_soft_deleted_keys_on_destroy    = false
      purge_soft_deleted_secrets_on_destroy = false
    }
  }

  skip_provider_registration = false
  storage_use_azuread        = true # when Shared Key Access is disabled, need to enable the storage_use_azuread.
}

data "azuread_client_config" "current" {}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.8"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  domain       = "plz"
  generator = {
    domain = {
      random = 100
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.domain.random[2]
  location            = module.naming.location
}

# Example of normal storage account
# module "storage_account" {
#   source              = "../."
#   resource_group_name = module.resource_group.name
#   name                = replace(module.naming.generated_names.domain.random[3], "-", "")
#   location            = module.naming.location
#   key_vault_id        = var.key_vault_id
# }
