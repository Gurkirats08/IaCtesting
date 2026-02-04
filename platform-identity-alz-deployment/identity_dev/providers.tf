terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.2.0"
    }
     time = {
      source = "hashicorp/time"
      version = ">= 0.12.0"
    }
        null = {
      source  = "hashicorp/null"
      version = "~> 3.1" 
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"  
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.1"
    }
     azapi = {
      source = "azure/azapi"
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
  subscription_id = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
  skip_provider_registration = true
  storage_use_azuread = true
}

provider "azurerm" {
  alias = "IdentitySub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  subscription_id     = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
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


# provider "azurerm" {
#   alias = "sharedSub"
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }
#   storage_use_azuread = true
#   subscription_id     = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
# }


provider "azapi" {
  
}


