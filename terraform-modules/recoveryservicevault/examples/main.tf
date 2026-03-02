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

#This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source      = "Azure/naming/azurerm"
  version     = ">= 0.3.0"
  suffix      = concat(var.suffix, ["infra-deploy"])
  prefix      = ["core42"]
  unique-seed = "01"
}

module "resource_group" {
  source   = "../../../infrasturcture/resource-group"
  location = "East US"
  name     = module.naming.resource_group.name_unique
}

