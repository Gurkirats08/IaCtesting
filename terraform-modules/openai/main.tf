resource "random_integer" "this" {
  max = 999999
  min = 100000
}

locals {
  account_name          = var.account_name
  custom_subdomain_name = coalesce(var.custom_subdomain_name, "azure-openai-${random_integer.this.result}")
  tags = var.default_tags_enabled ? {
    Application_Name = var.application_name
    Environment      = var.environment
  } : {}
  location = var.location
}

resource "azurerm_cognitive_account" "this" {
  kind                               = "CognitiveServices"
  location                           = local.location
  name                               = local.account_name
  resource_group_name                = var.resource_group_name
  sku_name                           = var.sku_name
  custom_subdomain_name              = local.custom_subdomain_name
  dynamic_throttling_enabled         = var.dynamic_throttling_enabled
  fqdns                              = var.fqdns
  local_auth_enabled                 = var.local_auth_enabled
  outbound_network_access_restricted = var.outbound_network_access_restricted
  public_network_access_enabled      = var.public_network_access_enabled
  tags                               = local.tags

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      identity_client_id = customer_managed_key.value.identity_client_id
    }
  }
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # network_acls {  
  #     default_action = var.network_acls.default_action
  #     ip_rules       = var.network_acls.ip_rules
  #     dynamic "virtual_network_rules" {
  #       for_each = var.network_acls.virtual_network_rules != null ? var.network_acls.virtual_network_rules : []
  #       content {
  #         subnet_id                            = virtual_network_rules.value.subnet_id
  #         ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
  #       }
  #     }

    
  # }



  dynamic "storage" {
    for_each = var.storage
    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }
  }
}

resource "azurerm_cognitive_deployment" "this" {
  for_each = var.deployment
  sku {
    name     = each.value.sku_name
    capacity = each.value.sku_capacity
    }
  cognitive_account_id = azurerm_cognitive_account.this.id
  name                 = each.value.name
  rai_policy_name      = each.value.rai_policy_name

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }
}