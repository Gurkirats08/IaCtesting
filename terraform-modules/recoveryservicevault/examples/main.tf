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

# Module for the recovery-services-vault tesing 
module "test" {
  source                            = "../"
  location                          = "East US"
  resource_group_name               = module.resource_group.name
  recovery_services_vault_name      = module.naming.recovery_services_vault.name_unique
  identity_type                     = "UserAssigned"
  infrastructure_encryption_enabled = true
  encryption_key_id                 = "https://keyiac001.vault.azure.net/keys/iac/188b0491fc9844bc8111f4667ea5b67f"
  identity_ids                      = ["/subscriptions/3ad40d2e-2752-487a-90e2-aa188707bdd3/resourceGroups/resourcetestdemo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/manage_id_iac"]
  user_assigned_identity_id         = "/subscriptions/3ad40d2e-2752-487a-90e2-aa188707bdd3/resourceGroups/resourcetestdemo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/manage_id_iac"
  use_system_assigned_identity      = false
}
