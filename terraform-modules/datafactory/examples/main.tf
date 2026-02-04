terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.48"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
  storage_use_azuread        = true
  skip_provider_registration = false
}

data "azuread_client_config" "current" {}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.8"
  product_area = "tcg"
  environment  = "development"
  location     = "australiaeast"
  domain       = "dcpadf"
  generator = {
    domain = {
      random                 = 200
      virtual_network        = 121
      data_factory           = 134
      virtual_network        = 112
      subnet                 = 165
      key_vault              = 101
      network_interface      = 123
      private_endpoint       = 145
      user_assigned_identity = 190
      virtual_machine        = 2
      data_factory_shir      = 2
      key_vault_secret       = 2
      storage_account        = 2
    }
  }
}

module "resource_group" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-resource-group?ref=1.0.1"
  resource_group_name = module.naming.generated_names.domain.random[175]
  location            = module.naming.location
}

module "virtual_network" {
  source               = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-virtual-network?ref=1.0.1"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.naming.generated_names.domain.virtual_network[78]
  address_space        = ["10.100.0.0/16"]
  location             = module.naming.location
}

module "subnet" {
  source                  = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-subnet?ref=1.0.3"
  resource_group_name     = module.resource_group.name
  subnet_name             = module.naming.generated_names.domain.subnet[95]
  virtual_network_name    = module.virtual_network.name
  address_prefixes        = "10.100.1.0/26"
  delegation_name         = "sqlmi"
  service_delegation_name = "Microsoft.Sql/managedInstances"
  service_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
  ]
}

# module "private_dns_zone" {
#   source                = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-dns-zone?ref=1.0.1"
#   private_dns_zone_name = "privatelink.datafactory.azure.net"
#   resource_group_name   = module.resource_group.name
# }

# module "private_endpoint" {
#   source                         = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
#   location                       = module.naming.location
#   resource_group_name            = module.resource_group.name
#   privateendpoint_name           = module.naming.generated_names.domain.private_endpoint[55]
#   subnet_id                      = module.subnet.id
#   custom_network_interface_name  = module.naming.generated_names.domain.network_interface[55]
#   private_dns_zone_group_name    = "null"
#   private_dns_zone_ids           = [module.private_dns_zone.id]
#   private_connection_resource_id = module.data_factory.data_factory_id
#   subresource_names              = ["dataFactory"]
# }

# module "private_endpoint_adf_portal" {
#   source                         = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
#   location                       = module.naming.location
#   resource_group_name            = module.resource_group.name
#   privateendpoint_name           = module.naming.generated_names.domain.private_endpoint[0]
#   subnet_id                      = module.subnet.id
#   custom_network_interface_name  = module.naming.generated_names.domain.network_interface[0]
#   private_dns_zone_group_name    = "null"
#   private_dns_zone_ids           = [module.private_dns_zone.id]
#   private_connection_resource_id = module.data_factory.data_factory_id
#   subresource_names              = ["portal"]
# }

module "key_vault" {
  source                   = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault?ref=1.0.5"
  resource_group_name      = module.resource_group.name
  azurerm_key_vault_name   = module.naming.generated_names.domain.key_vault[20]
  location                 = module.naming.location
  tenant_id                = data.azuread_client_config.current.tenant_id
  purge_protection_enabled = true
  sku_name                 = "premium"
  ip_rules                 = local.ip_rules
}

data "azurerm_role_definition" "key_vault_role" { name = "Key Vault Administrator" }

resource "azurerm_role_assignment" "user" {
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role.id
  principal_id       = "d4cd7563-e10c-4a18-afc6-61f09f07d8d9" # Graef, Sebastian

  lifecycle {
    ignore_changes = [
      role_definition_id
    ]
  }
}
resource "azurerm_role_assignment" "user2" {
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role.id
  principal_id       = "0f1d1702-7940-4a3e-a5a6-1c533a4e09ee" # Bulusu, Aashrith

  lifecycle {
    ignore_changes = [
      role_definition_id
    ]
  }
}
# resource "azurerm_role_assignment" "spn" {
#   scope              = module.key_vault.id
#   role_definition_id = data.azurerm_role_definition.key_vault_role.id
#   principal_id       = data.azuread_client_config.current.object_id

#   lifecycle {
#     ignore_changes = [
#       role_definition_id
#     ]
#   }
# }
module "storage_account" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-storage-account?ref=1.0.7"
  resource_group_name = module.resource_group.name
  name                = module.naming.generated_names.domain.storage_account[1]
  location            = module.naming.location
  key_vault_id        = module.key_vault.id
  network_rules       = local.network_rules
  depends_on = [
    # azurerm_role_assignment.spn
  ]
}
module "windows_virtual_machine" {
  source                             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-vm-windows?ref=1.0.5"
  virtual_machine_name               = module.naming.generated_names.domain.virtual_machine[0]
  resource_group_name                = module.resource_group.name
  location                           = module.naming.location
  admin_username                     = "testuser"
  computer_name                      = module.naming.generated_names.domain.computer_name[0]
  subnet_id                          = module.subnet.id
  private_ip_address                 = "10.100.1.12"
  source_image_id                    = "/subscriptions/e0742857-f7e8-41d1-bebf-0cb667def1f8/resourceGroups/tcg-sbae-sig-rg-001/providers/Microsoft.Compute/galleries/tcgsbaeplzsig001/images/tcgsbaeplzsigd003/versions/1.0.5"
  network_interface_name             = module.naming.generated_names.domain.network_interface[0]
  key_vault_secret_name              = module.naming.generated_names.domain.key_vault_secret[0]
  storage_account_name               = module.storage_account.name
  storage_account_primary_access_key = module.storage_account.primary_access_key
  storage_account_uri                = module.storage_account.primary_blob_endpoint
  key_vault_id                       = module.key_vault.id
  depends_on = [
    module.subnet
  ]
  # this variable is only for module pipeline testing and not needed for real implemenation
  skip_kv_secert_add = true
}

# Instance 1

module "data_factory" {
  source                          = "../"
  data_factory_name               = module.naming.generated_names.domain.data_factory[12]
  resource_group_name             = module.resource_group.name
  location                        = module.naming.location
  managed_virtual_network_enabled = true
  key_vault_id                    = module.key_vault.id
  user_managed_identity_name      = module.naming.generated_names.domain.user_assigned_identity[56]
  identity_type                   = "UserAssigned"
  integration_runtime_azure = {
    azure_ir01 = {
      integration_runtime_custom_name = "AutoResolveIntegrationRuntime"
      integration_runtime_configuration = {
        compute_type     = "General"
        core_count       = 8
        time_to_live_min = 0
      }
    }
  }
  integration_runtime_shir = {
    shir01 = {
      integration_runtime_custom_name = "shir01-shared"
      integration_runtime_description = "Azure Self Hosted Integration Runtime to support pipelines from multiple Data Factories. Both DBA managed and Tenant managed."
      run_cse                         = false
      # virtual_machine_id              = module.windows_virtual_machine.id
    }
    shir02 = {
      integration_runtime_custom_name = "shir02-shared"
      integration_runtime_description = "Azure Self Hosted Integration Runtime to support pipelines from multiple Data Factories. Both DBA managed and Tenant managed."
      run_cse                         = false
    }
  }
  integration_runtime_ssis = {
    ssis1 = {
      integration_runtime_custom_name = "SSISIR01"
      integration_runtime_description = "SSIS Integration Runtime for tcp0040-ae-df-dcpazure-nprod-ssis01 (Dual Standby Pair)"
      integration_runtime_configuration = {
        node_size                        = "Standard_D2_v3"
        number_of_nodes                  = 1
        max_parallel_executions_per_node = 2
        edition                          = "Standard"
        license_type                     = "BasePrice"
        catalog_info = {
          server_endpoint        = "tcg-dvae-dcpx-sqlmi002.1d3b2b96d5a6.database.windows.net"
          administrator_login    = "DatabaseServices"
          administrator_password = "NK@D5Ssxrbs!0VGt@cF$JU&2F%ZE!BcA" #Temp for testing # Not Secure#
          dual_standby_pair_name = "SSISIR01-SSISIR02-standby-pair"
        }
        # custom_setup_script = {
        #   blob_container_uri = optional(string)
        #   sas_token          = optional(string)
        # }
        express_vnet_integration = {
          subnet_id = "/subscriptions/33d4c6fa-b815-4457-a171-68dfd5cc9d73/resourceGroups/tcg-npae-a4362-network-rg001/providers/Microsoft.Network/virtualNetworks/tcg-npae-a4362-vnet001/subnets/tcg-npae-a4362-snet006"
        }
      }
    }
  }
}

locals {
  network_rules = {
    default_action = "Deny"
    ip_rules = [
      "203.41.142.76",
      "203.41.142.77",
      "203.35.135.165",
      "203.35.135.168",
      "203.35.135.174",
      "203.35.185.76",
      "203.35.185.77",
      "20.53.53.224",
      "20.70.222.112",
      "104.210.230.26",
      "104.210.231.26",
      "104.209.104.3",
      "152.58.235.114"
    ]
    virtual_network_subnet_ids = []
  }

  ip_rules = [
    "203.41.142.76",
    "203.41.142.77",
    "203.35.135.165",
    "203.35.135.168",
    "203.35.135.174",
    "203.35.185.76",
    "203.35.185.77",
    "20.53.53.224",
    "20.70.222.112",
    "104.210.230.26",
    "104.210.231.26",
    "104.209.104.3",
    "152.58.235.114"
  ]
}
