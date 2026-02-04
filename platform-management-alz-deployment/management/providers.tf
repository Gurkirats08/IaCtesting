terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.2.0"
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
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id            = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
  skip_provider_registration = true
  storage_use_azuread        = true
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id            = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
  skip_provider_registration = true
  storage_use_azuread        = true
  alias                      = "mgmtSub"
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
  subscription_id     = "dac03557-6089-4127-ae8a-e343e5635de2"
}

provider "azurerm" {
  alias = "identitySub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # skip_provider_registration = true
  storage_use_azuread = true
  subscription_id     = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
}

provider "azurerm" {
  alias = "appSub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  # skip_provider_registration = true
  storage_use_azuread = true
  subscription_id     = "7aa47d17-9de7-4605-a94f-3125b877f57d"
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
#   subscription_id     = "6c55b3c2-3d8e-40e8-85cf-a95d842095ac"
# }