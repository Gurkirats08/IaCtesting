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
  features {}
  skip_provider_registration = false
}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.5"
  product_area = "tcg"
  environment  = "development"
  # added to south east as location because in single subscription only one network watcher
  # can be created in a specific location  
  # which already exists tcg-sbae-sandbox-nw001 and that's why pipeline failing
  location = "australiasoutheast"
  generator = {
    plz = {
      random          = 1
      network_watcher = 1
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.plz.random[0]
  location            = module.naming.location
}

module "networkwatcher" {
  source               = "../."
  network_watcher_name = module.naming.generated_names.plz.network_watcher[0]
  resource_group_name  = module.resource_group.name
  location             = module.naming.location
}
