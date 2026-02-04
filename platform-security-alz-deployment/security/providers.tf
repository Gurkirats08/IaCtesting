terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.2.0"
    }
        time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "dac03557-6089-4127-ae8a-e343e5635de2"
  skip_provider_registration = true
    storage_use_azuread = true
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "dac03557-6089-4127-ae8a-e343e5635de2"
  skip_provider_registration = true
  storage_use_azuread = true
  alias = "SecuritySub"
}
provider "azurerm" {
  alias = "securitySub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # skip_provider_registration = true
  storage_use_azuread = true
  subscription_id = "dac03557-6089-4127-ae8a-e343e5635de2"
}

provider "azurerm" {
  alias = "connSub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  subscription_id     = "f8ad85d0-f173-426c-804e-972cc19ea770"
}