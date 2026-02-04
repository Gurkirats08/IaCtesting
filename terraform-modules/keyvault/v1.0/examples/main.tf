terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.113.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = false
}

data "azurerm_client_config" "current" {}

module "naming" {
  source      = "Azure/naming/azurerm"
  version     = ">= 0.3.0"
  suffix      = ["infra-deploy"]
  prefix      = ["core42"]
  unique-seed = "01"
}

module "rg" {
  source              = "../../resource-group"
  resource_group_name = module.naming.resource_group.name_unique
  location            = "East US"
}

module "kv" {
  source              = "../"
  resource_group_name = module.rg.name
  key_vault_location  = "East US"
  key_vault_name      = module.naming.key_vault.name_unique
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  enabled_for_rbac_authorization = false
  access_policy = [{
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "c852e973-6c99-4b59-b28f-3033ff308cfc"
    key_permissions = [
      "Get",
      "List",
      "Create"
    ]
  },
  {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
      "List",
      "Create"
    ]
  }]
  network_acls = {
    default_action = "Allow"
    bypass = "AzureServices"
  }
}