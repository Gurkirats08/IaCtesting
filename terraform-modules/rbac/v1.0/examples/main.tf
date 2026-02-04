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
  unique-seed = "02"
}

module "resource_group_name" {
  source              = "../../resource-group"
  resource_group_name = module.naming.resource_group.name_unique
  location            = "southindia"
}

module "test" {
  source               = "../"
  scope                = module.resource_group_name.id
  principal_id         = data.azurerm_client_config.this.object_id
  role_definition_name = "Storage Account Contributor"
  depends_on           = [module.resource_group_name]
}