terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = false
}

data "azuread_client_config" "current" {}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.2"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  generator = {
    plz = {
      random         = 1
      resource_group = 1
    }
  }
}

module "resource_group" {
  source              = "../."
  resource_group_name = module.naming.generated_names.plz.random[0]
  location            = module.naming.location
}
