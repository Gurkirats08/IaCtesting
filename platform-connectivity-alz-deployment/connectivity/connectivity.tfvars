# global variables
environment  = "dev"
mainLocation = "uaenorth"


connSubscriptionId      = "f8ad85d0-f173-426c-804e-972cc19ea770"
terraformStorageRG      = "rg-devops-sao-conn-eus-033"
terraformStorageAccount = "stsaoconndevopseus033"
security_subsId         = "dac03557-6089-4127-ae8a-e343e5635de2"
runnerVnetRg            = "Contos-ADO-Runners"
runnerVnetName          = "Contos-ADO-Runners-vnet"
runnerSubnetName        = "default"


# Storage Account Data Block
storageAccountResourceGroupName = "rgsfstac001"
storageAccountName              = "stsfstac001"


# Multiple Resource Groups

resourceGroups = {
  dnsRG = {
    name     = "rg-dns-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  migRG = {
    name     = "rg-mig-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  netRG = {
    name     = "rg-net-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  paasRG = {
    name     = "rg-paas-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  basRG = {
    name     = "rg-bas-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  mgmtRG = {
    name     = "rg-mgmt-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  backupRG = {
    name     = "rg-backup-conn-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  }
}




#NSG

connNetworkSecurityGroups = {
  nsg-net-sao-conn-eus-001 = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    name              = "nsg-net-sao-conn-eus-001"
    securityRules = [
      {
        name = "Block-SSH"
        properties = {
          priority                 = 100
          direction                = "Inbound"
          access                   = "Deny"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "22"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-HTTP"
        properties = {
          priority                 = 110
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "80"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-HTTPS"
        properties = {
          priority                 = 120
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "443"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Block-ICMP"
        properties = {
          priority                 = 130
          direction                = "Inbound"
          access                   = "Deny"
          protocol                 = "Icmp"
          sourcePortRange          = "*"
          destinationPortRange     = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Deny-All-Inbound"
        properties = {
          priority                 = 4096
          direction                = "Inbound"
          access                   = "Deny"
          protocol                 = "*"
          sourcePortRange          = "*"
          destinationPortRange     = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-All-Outbound"
        properties = {
          priority                 = 4096
          direction                = "Outbound"
          access                   = "Allow"
          protocol                 = "*"
          sourcePortRange          = "*"
          destinationPortRange     = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      }
    ]
  }
  nsg-net-sao-conn-bas-001 = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    name              = "nsg-net-sao-conn-bas-001"
    securityRules = [
      {
        name = "Allow-HTTPS-Inbound"
        properties = {
          priority                 = 120
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "443"
          sourceAddressPrefix      = "Internet"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-Gateway-Inbound"
        properties = {
          priority                 = 130
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "443"
          sourceAddressPrefix      = "GatewayManager"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-LoadBalancer-Inbound"
        properties = {
          priority                 = 140
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "443"
          sourceAddressPrefix      = "AzureLoadBalancer"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-Bastion-Inbound"
        properties = {
          priority                 = 150
          direction                = "Inbound"
          access                   = "Allow"
          protocol                 = "*"
          sourcePortRange          = "*"
          destinationPortRanges    = ["8080", "5701"]
          sourceAddressPrefix      = "VirtualNetwork"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Deny-All-Inbound"
        properties = {
          priority                 = 4096
          direction                = "Inbound"
          access                   = "Deny"
          protocol                 = "*"
          sourcePortRange          = "*"
          destinationPortRange     = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "*"
        }
      },
      {
        name = "Allow-SSH-RDP-Outbound"
        properties = {
          priority                 = 100
          direction                = "Outbound"
          access                   = "Allow"
          protocol                 = "*"
          destinationPortRanges    = ["22", "3389"]
          sourcePortRange          = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "VirtualNetwork"
        }
      },
      {
        name = "Allow-Azure-Cloud-Outbound"
        properties = {
          priority                 = 110
          direction                = "Outbound"
          access                   = "Allow"
          protocol                 = "Tcp"
          sourcePortRange          = "*"
          destinationPortRange     = "443"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "AzureCloud"
        }
      },
      {
        name = "Allow-Bastion-Outbound"
        properties = {
          priority                 = 120
          direction                = "Outbound"
          access                   = "Allow"
          protocol                 = "*"
          destinationPortRanges    = ["8080", "5701"]
          sourcePortRange          = "*"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "VirtualNetwork"
        }
      },
      {
        name = "Allow-Http-Outbound"
        properties = {
          priority                 = 130
          direction                = "Outbound"
          access                   = "Allow"
          protocol                 = "*"
          sourcePortRange          = "*"
          destinationPortRange     = "80"
          sourceAddressPrefix      = "*"
          destinationAddressPrefix = "Internet"
        }
      }
    ]
  }
}

# virtual network
connVirtualNetworks = {
  vnet-net-sao-conn-eus-001 = {
    resourceGroupName  = "rg-net-conn-prd-sao-aen-001"
    subscriptionId     = "f8ad85d0-f173-426c-804e-972cc19ea770"
    VirtualNetworkName = "vnet-net-sao-conn-eus-001"
    address_space      = "172.29.0.0/23"
    bastionIPName      = "bastion-ip-bas-sao-conn-eus-001"
    sku_name           = "Standard"
    bastionName        = "bastion-bas-sao-conn-eus-001"
    bastion_sku        = "Standard"
    # DDosProtectionPlan = "ddos-sao-conn-eus-017"
  }
}

connSubnets = {
  vnet-net-sao-conn-eus-001_gatewaysubnet = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    vnet_key          = "vnet-net-sao-conn-eus-001"
    name              = "gatewaysubnet"
    addressPrefix     = "172.29.0.32/27"
    vnet_name         = "vnet-net-sao-conn-eus-001"
    subscriptionId    = "f8ad85d0-f173-426c-804e-972cc19ea770"
    routeTableName    = "rt-net-sao-conn-eus-001-1"
  },
  vnet-net-sao-conn-eus-001_AzureFirewallSubnet = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    vnet_key          = "vnet-net-sao-conn-eus-001"
    name              = "AzureFirewallSubnet"
    addressPrefix     = "172.29.0.128/25"
    vnet_name         = "vnet-net-sao-conn-eus-001"
    subscriptionId    = "f8ad85d0-f173-426c-804e-972cc19ea770"
    routeTableName    = "rt-net-sao-conn-eus-001-2"
  }
  vnet-net-sao-conn-eus-001_ksp-pcw-conn-platform-ci-vnet-01-snet-01 = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    vnet_key          = "vnet-net-sao-conn-eus-001"
    name              = "ksp-pcw-conn-platform-ci-vnet-01-snet-01"
    addressPrefix     = "172.29.0.64/26"
    vnet_name         = "vnet-net-sao-conn-eus-001"
    subscriptionId    = "f8ad85d0-f173-426c-804e-972cc19ea770"
    nsgName           = "nsg-net-sao-conn-eus-001"
    routeTableId      = null
  }
  vnet-net-sao-conn-eus-001_ksp-pcw-conn-platform-ci-vnet-01-snet-02 = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    vnet_key          = "vnet-net-sao-conn-eus-001"
    name              = "ksp-pcw-conn-platform-ci-vnet-01-snet-02"
    addressPrefix     = "172.29.1.0/26"
    vnet_name         = "vnet-net-sao-conn-eus-001"
    subscriptionId    = "f8ad85d0-f173-426c-804e-972cc19ea770"
    nsgName           = "nsg-net-sao-conn-eus-001"
    routeTableId      = null
  }
  vnet-net-sao-conn-eus-001_AzureBastionSubnet = {
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
    vnet_key          = "vnet-net-sao-conn-eus-001"
    name              = "AzureBastionSubnet"
    addressPrefix     = "172.29.1.64/26"
    vnet_name         = "vnet-net-sao-conn-eus-001"
    subscriptionId    = "f8ad85d0-f173-426c-804e-972cc19ea770"
    nsgName           = null
    routeTableId      = null
  }
}


connRouteTables = {
  rt-net-sao-conn-eus-001-1 = {
    resourceGroupName         = "rg-net-conn-prd-sao-aen-001"
    routeTableName            = "rt-net-sao-conn-eus-001-1"
    enableBgpRoutePropagation = false
    routes = [{
      name             = "ksp-pcw-conn-platform-ci-route-01"
      addressPrefix    = "172.29.0.32/27"
      NextHopIpAddress = "172.29.0.132"
      nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-conn-platform-ci-route-02"
        addressPrefix    = "172.29.0.128/25"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-conn-platform-ci-route-03"
        addressPrefix    = "172.29.0.64/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-conn-platform-ci-route-04"
        addressPrefix    = "172.29.1.0/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      }
    ]
  }
  rt-net-sao-conn-eus-001-2 = {
    resourceGroupName         = "rg-net-conn-prd-sao-aen-001"
    routeTableName            = "rt-net-sao-conn-eus-001-2"
    enableBgpRoutePropagation = false
    routes = [{
      name          = "ksp-pcw-conn-platform-ci-route-01"
      addressPrefix = "0.0.0.0/0"
      nextHopType   = "Internet"
    }]
  }
}

#----------------------------------------------------------


# Firewalls

connFirewalls = {
  ksp-pcw-conn-platform-ci-fw-01 = {
    firewallName               = "ksp-pcw-conn-platform-ci-fw-01"
    firewallSkuTier            = "Standard"
    vNetName                   = "vnet-net-sao-conn-eus-001"
    resourceGroupName          = "rg-net-conn-prd-sao-aen-001"
    subscriptionId             = "f8ad85d0-f173-426c-804e-972cc19ea770"
    firewallIPName             = "ksp-pcw-conn-platform-ci-fw-pip-01"
    firewallIpAllocationMethod = "Static"
    firewallSkuName            = "Standard"
    zones = [
      1
    ]
    firewallPolicyName = "ksp-pcw-conn-platform-ci-fw-policy-01"
    firewallPolicyTier = "Standard"
    threatIntelMode    = "Alert"
    firewallPolicyRuleCollectionGroups = [
      {
        name     = "DefaultApplicationRuleCollectionGroup"
        priority = 300
        ruleCollections = [
          {
            ruleCollectionType = "firewallPolicyFilterRuleCollection"
            action = {
              type = "Deny"
            }
            rules = [
              {
                ruleType = "ApplicationRule"
                name     = "Block_google"
                protocols = [
                  {
                    protocolType = "Http"
                    port         = 80
                  },
                  {
                    protocolType = "Https"
                    port         = 443
                  }
                ]
                terminateTLS = false
                targetFqdns = [
                  "*.microsoft.com"
                ]
                sourceAddresses = [
                  "0.0.0.0"
                ]
              }
            ]
            name     = "Azurefirewall_Internet_Deny"
            priority = 101
          }
        ]
      }
    ]
  }
}

#----------------------------------------------------------


connDDos = {
  ddos-sao-conn-eus-001 = {
    name              = "ddos-net-sao-conn-eus-001"
    resourceGroupName = "rg-net-conn-prd-sao-aen-001"
  }
}

# # RBACS

# connRbacs = {
#   kv = {
#     resource_name        = "kv-sao-conn-eus-001"
#     role_definition_name = "Key Vault Administrator"
#     subscriptionId       = "f8ad85d0-f173-426c-804e-972cc19ea770"
#     provider             = "Microsoft.KeyVault"
#     resource_type        = "vaults"
#   }
# }


# # Storage Account

nsgFlowstorageAccountName              = "stgconnsao01"
nsgFlowstorageAccountResourceGroupName = "rg-paas-conn-prd-sao-aen-001"
subscriptionId                         = "f8ad85d0-f173-426c-804e-972cc19ea770"
subnetRG                               = "rg-net-conn-prd-sao-aen-001"

security_law_name                      = "law-sao-sec-eus-001"
security_law_rg                        = "rg-mgmt-sec-prd-sao-aen-001"


# # Private Endpoint

connPrivateEndpoint = {
  "pe1" = {
    private_endpoint_name          = "pe-sao-conn-eus-001-1"
    resource_group_name            = "rg-mig-conn-prd-sao-aen-001"
    location                       = "uaenorth"
    subnet_id                      = "vnet-net-sao-conn-eus-001_ksp-pcw-conn-platform-ci-vnet-01-snet-01"
    private_dns_zone_id            = "vaultcore"
    private_connection_resource_id = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
    subresource_names              = ["blob"]
  }
  #private endpoint for backend storage account
  "pe2" = {
    private_endpoint_name          = "pe-sao-conn-aen-001-tfstorage"
    resource_group_name            = "rg-devops-sao-conn-eus-033"
    location                       = "uaenorth"
    private_dns_zone_id            = "vaultcore"
    subnet_id                      = "vnet-net-sao-conn-eus-001_ksp-pcw-conn-platform-ci-vnet-01-snet-01"
    private_connection_resource_id = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-devops-sao-conn-eus-033/providers/Microsoft.Storage/storageAccounts/stsaoconndevopseus033"
    subresource_names              = ["blob"]
  }
}


# # Hardware Security Module (HSM)

connHSM = {
  name                = "Sec-hsm01"
  resource_group_name = "rg-sec-hsm-sao-aen-001"
}
hsmKeyName = "hsm-key-conn-01"

connIdentity = "ua-conn-identity"


# # Key Vault

# connKeyVaults = {
#   kv-sao-conn-eus-001 = {
#     name     = "kv-sao-conn-eus-001"
#     location = "uaenorth"
#     sku      = "premium"
#   }
# }


# # Key Vault Key

# connKeyVaultKeys = {
#   cmkKv = {
#     key_name = "cmk-kv"
#     key_type = "RSA-HSM"
#     key_opts = [
#       "decrypt",
#       "encrypt",
#       "sign",
#       "unwrapKey",
#       "verify",
#       "wrapKey"
#     ]
#     expiration_date = "2026-01-01T00:00:00Z"
#   }
#   cmkKv2 = {
#     key_name = "cmk-kv2"
#     key_type = "RSA"
#     key_opts = [
#       "decrypt",
#       "encrypt",
#       "sign",
#       "unwrapKey",
#       "verify",
#       "wrapKey"
#     ]
#     expiration_date = "2026-01-01T00:00:00Z"
#   }
# }



# Network Watcher [created automatically]
network_watcher_rg   = "NetworkWatcherRG"
network_watcher_name = "NetworkWatcher_uaenorth"

#Mgmt nsg flow log
connFlowLog = {
  nsg_flow_log_name = "flow-log-sao-conn-aen-001"
  location          = "uaenorth"
  nsgId             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-net-conn-prd-sao-aen-001/providers/Microsoft.Network/networkSecurityGroups/nsg-net-sao-conn-eus-001"
}



backupVaultName = "conn-backupvault-01"

storagebackupPolicies = {
  "policy1" = {
    backup_policy_name               = "backuppolicy-conn-platform-blob01"
    backup_vault_Name                = "conn-backupvault-01"
    vault_default_retention_duration = "P30D"
    conn_sub_id                      = "f8ad85d0-f173-426c-804e-972cc19ea770"
    location                         = "uaenorth"
    backup_instance_name             = "blob-backup-instance-01"
    resource_group_name              = "rg-backup-conn-prd-sao-aen-001"
  }
}


connPrivateDNSZones = {
  "vaultcore" = {
    name              = "privatelink.vaultcore.azure.net"
    resourceGroupName = "rg-dns-conn-prd-sao-aen-001"
  },
  "blob" = {
    name              = "privatelink.blob.core.windows.net"
    resourceGroupName = "rg-dns-conn-prd-sao-aen-001"
  }
}

connResourceLocks = {
  "lock1" = {
    name                = "Lock-paasRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-paas-conn-prd-sao-aen-001"
  },
  "lock2" = {
    name                = "Lock-netRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-net-conn-prd-sao-aen-001"
  },
  "lock3" = {
    name                = "Lock-mgmtRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-mgmt-conn-prd-sao-aen-001"
  },
  "lock4" = {
    name                = "Lock-migRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-mig-conn-prd-sao-aen-001"
  }
  "lock5" = {
    name                = "Lock-basRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-bas-conn-prd-sao-aen-001"
  }
  "lock6" = {
    name                = "Lock-backupRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-backup-conn-prd-sao-aen-001"
  }
  "lock7" = {
    name                = "Lock-dnsRG-conn-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-dns-conn-prd-sao-aen-001"
  }
}

diagnostic_logs = {
  "storage_account_1" = {
    name                           = "diag-setting-storage1"
    target_resource_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
    storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
    log_analytics_workspace_id     = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
    eventhub_name                  = null
    eventhub_authorization_rule_id = null
    logs_categories                = []
    metrics                        = ["AllMetrics"]
  }
    #Uncomment according to custome rrequirements:

  // "sql_instance_1" = {
  //   name                           = "diag-setting-sql1"
  //   target_resource_id             = "xxx"
  //   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  //   log_analytics_workspace_id     = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  //   eventhub_name                  = null
  //   eventhub_authorization_rule_id = null
  //   logs_categories                = []
  //   metrics                        = ["AllMetrics"]
  // }
  # "kv_1" = {
  #   name                           = "diag-setting-kv1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "vnet" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "rsv" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "backupvault" = {
  #   name                           = "diag-setting-backupvault1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "bastion" = {
  #   name                           = "diag-setting-bastion1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-paas-conn-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgconnsao01"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }
}







