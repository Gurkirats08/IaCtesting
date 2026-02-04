terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "this" {}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source      = "Azure/naming/azurerm"
  version     = ">= 0.3.0"
  suffix      = concat(var.suffix, ["infra-deploy"])
  prefix      = ["core42"]
  unique-seed = "01"
}

module "resource_group_name" {
  source   = "../../resource-group"
  resource_group_name    = module.naming.resource_group.name_unique
  location = "southindia"
}

module "kv" {
  source              = "../../key-vault"
  resource_group_name = module.rg.name
  key_vault_location  = "southindia"
  key_vault_name      = module.naming.key_vault.name_unique
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

module "test" {
  source = "../"
  key_vault_id = module.kv.id
  key_type = "RSA"
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}