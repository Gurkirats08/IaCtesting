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
}

data "azurerm_client_config" "current" {}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.5"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  generator = {
    plz = {
      random               = 1
      application_insights = 1
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.plz.random[0]
  location            = module.naming.location
}

module "application_insights" {
  source                   = "../."
  application_insight_name = module.naming.generated_names.plz.application_insights[0]
  resource_group_name      = module.resource_group.name
  location                 = module.naming.location
  application_type         = var.application_type
}
