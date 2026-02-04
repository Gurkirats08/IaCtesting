terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.25"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = false
}

data "azuread_client_config" "current" {}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.7"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  domain       = "plz"
  generator = {
    domain = {
      random             = 1
      eventhub_namespace = 1
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.domain.random[0]
  location            = module.naming.location
}

module "eventhub_namespace" {
  source                          = "../."
  resource_group_name             = module.resource_group.name
  location                        = module.naming.location
  azurerm_eventhub_namespace_name = module.naming.generated_names.domain.eventhub_namespace[0]
  zone_redundant                  = true
  local_authentication_enabled    = true
  public_network_access_enabled   = true
  network_rulesets                = var.network_rulesets
  key_vault_id                    = var.key_vault_id
}
