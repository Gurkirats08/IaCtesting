resource "random_password" "random" {
  keepers = {
    salt = "pepper"
  }
  length  = 6
  special = false
  lower   = true
}

resource "azurerm_data_factory" "this" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.location

  managed_virtual_network_enabled  = var.managed_virtual_network_enabled
  public_network_enabled           = false
  customer_managed_key_id          = var.identity_type != "SystemAssigned" ? var.customer_managed_key_id == null ? azurerm_key_vault_key.this.id : var.customer_managed_key_id : null
  customer_managed_key_identity_id = var.identity_type != "SystemAssigned" ? var.customer_managed_key_identity_id == null ? azurerm_user_assigned_identity.adf_user_managed_identity[0].id : var.customer_managed_key_identity_id : null
  tags                             = merge(local.tags, var.tags)

  dynamic "github_configuration" {
    for_each = toset(var.github_configuration == null ? [] : [var.github_configuration])

    content {
      account_name    = github_configuration.value.account_name
      branch_name     = github_configuration.value.branch_name
      git_url         = github_configuration.value.git_url
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
    }
  }

  dynamic "vsts_configuration" {
    for_each = toset(var.azure_devops_configuration == null ? [] : [var.azure_devops_configuration])

    content {
      account_name    = vsts_configuration.value.account_name
      branch_name     = vsts_configuration.value.branch_name
      project_name    = vsts_configuration.value.project_name
      repository_name = vsts_configuration.value.repository_name
      root_folder     = vsts_configuration.value.root_folder
      tenant_id       = vsts_configuration.value.tenant_id
    }
  }

  dynamic "global_parameter" {
    for_each = var.global_parameters

    content {
      name  = global_parameter.value.name
      value = global_parameter.value.value
      type  = global_parameter.value.type
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type != "SystemAssigned" ? [azurerm_user_assigned_identity.adf_user_managed_identity[0].id] : []
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "integration_runtime" {
  for_each = var.integration_runtime_azure

  data_factory_id = azurerm_data_factory.this.id
  name            = each.value.integration_runtime_custom_name
  location        = lookup(each.value.integration_runtime_configuration, "virtual_network_enabled", false) == true ? var.location : "AutoResolve"
  description     = each.value.integration_runtime_description

  cleanup_enabled         = lookup(each.value.integration_runtime_configuration, "cleanup_enabled", true)
  compute_type            = lookup(each.value.integration_runtime_configuration, "compute_type", "General")
  core_count              = lookup(each.value.integration_runtime_configuration, "core_count", 8)
  time_to_live_min        = lookup(each.value.integration_runtime_configuration, "time_to_live_min", 0)
  virtual_network_enabled = lookup(each.value.integration_runtime_configuration, "virtual_network_enabled", false)
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "integration_runtime" {
  for_each        = var.integration_runtime_shir
  data_factory_id = azurerm_data_factory.this.id
  name            = each.value.integration_runtime_custom_name
  description     = each.value.integration_runtime_description
  # dynamic "rbac_authorization" {
  #   for_each = lookup(each.value, "rbac_authorization", [])
  #   content {
  #     resource_id = rbac_authorization.id
  #   }
  # }
}

# TO DO : Fix the CSE #
resource "azurerm_virtual_machine_extension" "shir_cse" {
  for_each             = local.shir_cse
  name                 = "adf-shir-extension"
  virtual_machine_id   = try(split("||", each.value)[0], null)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings = jsonencode({
    "commandToExecute" = try(format("%s%s%s", "powershell -ExecutionPolicy Unrestricted -File ./gatewayInstall.ps1 ", azurerm_data_factory_integration_runtime_self_hosted.integration_runtime[split("||", each.value)[1]].primary_authorization_key, " && timeout /t 120"), null)
  })
}

resource "azurerm_data_factory_integration_runtime_azure_ssis" "integration_runtime" {
  for_each = var.integration_runtime_ssis

  data_factory_id = azurerm_data_factory.this.id
  name            = each.value.integration_runtime_custom_name
  location        = var.location
  description     = each.value.integration_runtime_description

  node_size                        = lookup(each.value.integration_runtime_configuration, "node_size", null)
  number_of_nodes                  = lookup(each.value.integration_runtime_configuration, "number_of_nodes", 1)
  max_parallel_executions_per_node = lookup(each.value.integration_runtime_configuration, "max_parallel_executions_per_node", 1)
  edition                          = lookup(each.value.integration_runtime_configuration, "edition", "Standard")
  license_type                     = lookup(each.value.integration_runtime_configuration, "license_type", "LicenseIncluded")
  dynamic "catalog_info" {
    for_each = each.value.integration_runtime_configuration.catalog_info != null ? [1] : []
    content {
      server_endpoint        = try(each.value.integration_runtime_configuration.catalog_info.server_endpoint, null)
      administrator_login    = try(each.value.integration_runtime_configuration.catalog_info.administrator_login, null)
      administrator_password = try(each.value.integration_runtime_configuration.catalog_info.administrator_password, null)
      pricing_tier           = try(each.value.integration_runtime_configuration.catalog_info.pricing_tier, null)
      elastic_pool_name      = try(each.value.integration_runtime_configuration.catalog_info.elastic_pool_name, null)
      dual_standby_pair_name = try(each.value.integration_runtime_configuration.catalog_info.dual_standby_pair_name, null)
    }
  }
  dynamic "custom_setup_script" {
    for_each = each.value.integration_runtime_configuration.custom_setup_script != null ? [1] : []
    content {
      blob_container_uri = try(each.value.integration_runtime_configuration.custom_setup_script.blob_container_uri, null)
      sas_token          = try(each.value.integration_runtime_configuration.custom_setup_script.sas_token, null)
    }
  }
  # dynamic "express_custom_setup" {
  #   for_each = lookup(each.value.integration_runtime_configuration, "express_custom_setup", [])
  #   content {
  #     command_key        = express_custom_setup.command_key
  #     component          = express_custom_setup.component
  #     environment        = express_custom_setup.environment
  #     powershell_version = express_custom_setup.powershell_version
  #   }
  # }
  dynamic "express_vnet_integration" {
    for_each = each.value.integration_runtime_configuration.express_vnet_integration != null ? [1] : []
    content {
      subnet_id = try(each.value.integration_runtime_configuration.express_vnet_integration.subnet_id, null)
    }
  }
  dynamic "package_store" {
    for_each = each.value.integration_runtime_configuration.package_store != null ? [1] : []
    content {
      name                = try(each.value.integration_runtime_configuration.package_store.name, null)
      linked_service_name = try(each.value.integration_runtime_configuration.package_store.linked_service_name, null)
    }
  }
  dynamic "proxy" {
    for_each = each.value.integration_runtime_configuration.proxy != null ? [1] : []
    content {
      self_hosted_integration_runtime_name = try(each.value.integration_runtime_configuration.proxy.self_hosted_integration_runtime_name, null)
      staging_storage_linked_service_name  = try(each.value.integration_runtime_configuration.proxy.staging_storage_linked_service_name, null)
      path                                 = try(each.value.integration_runtime_configuration.proxy.path, null)
    }
  }
  dynamic "vnet_integration" {
    for_each = each.value.integration_runtime_configuration.vnet_integration != null ? [1] : []
    content {
      vnet_id     = try(each.value.integration_runtime_configuration.vnet_integration.vnet_id, null)
      subnet_id   = try(each.value.integration_runtime_configuration.vnet_integration.subnet_id, null)
      subnet_name = try(each.value.integration_runtime_configuration.vnet_integration.subnet_name, null)
      public_ips  = try(each.value.integration_runtime_configuration.vnet_integration.public_ips, null)
    }
  }
}

/*
In order to enable CMK the managed identity needs to be granted Key Vault Crypto User/Service Encryption User.
https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-byok-overview?view=azuresql
https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
*/
## ADF Supports Customer managed Key only with a user managed identity ##


resource "time_static" "current_time" {}

resource "time_offset" "two_years" {
  offset_years = 2
}

locals {
  sub_id                                    = split("/", var.key_vault_id)[2]
  kv_administrator_role_id                  = "00482a5a-887f-4fb3-b363-3b7fe8e74483" # "Key Vault Administrator"
  kv_crypto_user_role_id                    = "12338af0-0e69-4776-bea7-57ae8d297424" # "Key Vault Crypto User"
  kv_crypto_officer_role_id                 = "c099189e-ab4a-499b-9475-b29bba3d238c" # "Key Vault Crypto Officer"
  kv_crypto_service_encryption_user_role_id = "e147488a-f6f5-4113-8e2d-b22465e65bf6" # "Key Vault Crypto Service Encryption User"
}

resource "azurerm_user_assigned_identity" "adf_user_managed_identity" {
  count               = (var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned") && (var.identity_ids != []) ? 1 : 0
  location            = var.location
  name                = var.user_managed_identity_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "this" {
  count              = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? 1 : 0
  scope              = var.key_vault_id
  role_definition_id = format("/subscriptions/%s%s", data.azurerm_subscription.current.subscription_id, data.azurerm_role_definition.kv_crypto_service_encryption_user_role.id)
  principal_id       = azurerm_user_assigned_identity.adf_user_managed_identity[0].principal_id
}

data "azurerm_role_definition" "kv_crypto_service_encryption_user_role" { name = "Key Vault Crypto Service Encryption User" }
data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "azurerm_key_vault_key" "this" {
  name            = format("%s-%s-%s", var.data_factory_name, "cmk", substr(random_password.random.result, 0, 5))
  key_vault_id    = var.key_vault_id
  key_type        = "RSA-HSM"
  key_size        = 2048
  not_before_date = time_offset.two_years.base_rfc3339 # time_static.current_time.rfc3339
  expiration_date = time_offset.two_years.rfc3339      #timeadd(time_static.current_time.rfc3339, "8760h")

  key_opts = [
    "unwrapKey",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P21M"
    }

    expire_after         = "P2Y"
    notify_before_expiry = "P30D"
  }

  depends_on = [
    azurerm_role_assignment.this
  ]
}
