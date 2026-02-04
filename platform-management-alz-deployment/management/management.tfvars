# global variables
environment        = "dev"
mgmtSubscriptionId = "60115b64-f08a-4207-bb4b-f8eb757aecd1"

HSM = {
  name        = "Sec-hsm01"
  hsm_rg_name = "rg-sec-hsm-sao-aen-001"
}

terraformStorageRG      = "rg-sao-devops-mgmt-aen-001"
terraformStorageAccount = "stmgmtdevopsaen020"
security_subsId         = "dac03557-6089-4127-ae8a-e343e5635de2"

# resource group
resourceGroups = {
  netRG = {
    name     = "rg-net-mgmt-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  mgmtRG = {
    name     = "rg-mgmt-mgmt-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  commonRG = {
    name     = "rg-common-mgmt-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  backupRG = {
    name     = "rg-backup-mgmt-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  }
}

mgmtResourceLocks = {
  "lock1" = {
    name                = "Lock-netRG-mgmt-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-net-mgmt-prd-sao-aen-001"
  },
  "lock2" = {
    name                = "Lock-mgmtRG-mgmt-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-mgmt-mgmt-prd-sao-aen-001"
  },
  "lock3" = {
    name                = "Lock-commonRG-mgmt-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-common-mgmt-prd-sao-aen-001"
  },
  "lock4" = {
    name                = "Lock-backupRG-mgmt-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-backup-mgmt-prd-sao-aen-001"
  }
}

# standalone variables for some resources
private_dns_zone_name       = "privatelink.blob.core.windows.net"
dnszone_resource_group_name = "rg-dns-conn-prd-sao-aen-001"
commonResourceGroupName     = "rg-common-mgmt-prd-sao-aen-001"
nsgFlowStorageAccountName   = "stgmgmtsao010"
mainLocation                = "uaenorth"
hsm_key_name                = "mgmt-hsm-key-03"
uai_name                    = "uai-sao-mgmt-aen-001"


# Mgmt User Assigned Identity
userAssignedIdentityName = {
  uai1 = {
    uai_name            = "uai-sao-mgmt-aen-001"
    location            = "uaenorth"
    resource_group_name = "rg-common-mgmt-prd-sao-aen-001"
  }
}



# Mgmt ddos protection plan
mgmtddos = {
  ddos1 = {
    name              = "ddos-net-mgmt-sao-aen-001"
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
  }
}



# Mgmt Virtual network
mgmtVirtualNetworks = {
  vnet-sao-mgmt-aen-001 = {
    resourceGroupName  = "rg-net-mgmt-prd-sao-aen-001"
    subscriptionId     = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
    VirtualNetworkName = "vnet-sao-mgmt-aen-001"
    address_space      = "192.168.0.0/23"
    bastionIPName      = "bastion-ipao-mgmt-aen-001"
    sku_name           = "Standard"
    bastionName        = "bastion-sao-mgmt-aen-001"
    DDosProtectionPlan = "ddos-net-mgmt-sao-aen-001"
  }
}

# Mgmt RT
mgmtRouteTables = {
  rt-sao-mgmt-aen-001-1 = {
    resourceGroupName             = "rg-net-mgmt-prd-sao-aen-001"
    routeTableName                = "rt-sao-mgmt-aen-001-1"
    bgp_route_propagation_enabled = true
    routes = [
      {
        name             = "ksp-pcw-mgmt-platform-ci-route-01"
        addressPrefix    = "192.168.0.0/27"
        NextHopIpAddress = "192.168.0.10"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-mgmt-platform-ci-route-02"
        addressPrefix    = "192.168.0.0/24"
        NextHopIpAddress = "192.168.0.10"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-mgmt-platform-ci-route-03"
        addressPrefix    = "192.168.0.0/26"
        NextHopIpAddress = "192.168.0.10"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-mgmt-platform-ci-route-04"
        addressPrefix    = "192.168.1.0/26"
        NextHopIpAddress = "192.168.0.10"
        nextHopType      = "VirtualAppliance"
      }
    ]
  }
  rt-sao-mgmt-aen-001-2 = {
    resourceGroupName             = "rg-net-mgmt-prd-sao-aen-001"
    routeTableName                = "rt-sao-mgmt-aen-017-2"
    bgp_route_propagation_enabled = true
    routes = [{
      name          = "ksp-pcw-mgmt-platform-ci-route-01"
      addressPrefix = "0.0.0.0/0"
      nextHopType   = "Internet"
    }]
  }
}

# Mgmt NSG
mgmtNetworkSecurityGroups = {
  nsg-sao-mgmt-aen-001 = {
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
    name              = "nsg-sao-mgmt-aen-001"
    securityRules = [
      {
        name = "Allow-SSH"
        properties = {
          priority                 = 100
          direction                = "Inbound"
          access                   = "Allow"
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
        name = "Allow-ICMP"
        properties = {
          priority                 = 130
          direction                = "Inbound"
          access                   = "Allow"
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
}

# Mgmt Subnets
mgmtSubnets = {
  vnet-sao-mgmt-aen-001_gatewaysubnet = {
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
    vnet_key          = "vnet-sao-mgmt-aen-001"
    name              = "gatewaysubnet"
    addressPrefix     = "192.168.0.0/27"
    vnet_name         = "vnet-sao-mgmt-aen-001"
  },
  vnet-sao-mgmt-aen-001_AzureFirewallSubnet = {
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
    vnet_key          = "vnet-sao-mgmt-aen-001"
    name              = "AzureFirewallSubnet"
    addressPrefix     = "192.168.0.128/25"
    vnet_name         = "vnet-sao-mgmt-aen-001"
  }
  vnet-sao-mgmt-aen-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-01 = {
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
    vnet_key          = "vnet-sao-mgmt-aen-001"
    name              = "ksp-pcw-mgmt-platform-ci-vnet-01-snet-01"
    addressPrefix     = "192.168.1.0/26"
    vnet_name         = "vnet-sao-mgmt-aen-001"
    subscriptionId    = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
    nsgName           = "nsg-sao-mgmt-aen-001"
    rtName            = "rt-sao-mgmt-aen-001-1"

  }
  vnet-sao-mgmt-aen-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-02 = {
    resourceGroupName = "rg-net-mgmt-prd-sao-aen-001"
    vnet_key          = "vnet-sao-mgmt-aen-001"
    name              = "ksp-pcw-mgmt-platform-ci-vnet-01-snet-02"
    addressPrefix     = "192.168.1.64/26"
    vnet_name         = "vnet-sao-mgmt-aen-001"
    subscriptionId    = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
    nsgName           = "nsg-sao-mgmt-aen-001"
    rtName            = "rt-sao-mgmt-aen-001-1"

  }
}
private_endpoint_network_policies = "Disabled"

# Mgmt PEs
mgmtPrivateEndpoint = {
  "pe1" = {
    private_endpoint_name          = "pe-sao-mgmt-aen-001-storage"
    resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
    location                       = "uaenorth"
    subnet_id                      = "vnet-sao-mgmt-aen-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-01"
    private_dns_zone_id            = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_connection_resource_id = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourcegroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
    subresource_names              = ["blob"]
  },
  "pe2" = {
    private_endpoint_name          = "pe-sao-mgmt-aen-001-tfstorage"
    resource_group_name            = "rg-sao-devops-mgmt-aen-001"
    location                       = "uaenorth"
    subnet_id                      = "vnet-sao-mgmt-aen-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-01"
    private_dns_zone_id            = "/subscriptions/f8ad85d0-f173-426c-804e-972cc19ea770/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_connection_resource_id = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-sao-devops-mgmt-aen-001/providers/Microsoft.Storage/storageAccounts/stmgmtdevopsaen020"
    subresource_names              = ["blob"]
  }
}

# Network Watcher [created automatically]
network_watcher_name = "NetworkWatcher_uaenorth"
network_watcher_rg   = "NetworkWatcherRG"

# Mgmt nsg flow log
mgmtFlowLogs = {
  flowlog1 = {
    nsg_flow_log_name = "flow-log-sao-mgmt-aen-001"
    nsgName           = "nsg-sao-mgmt-aen-001"
    location          = "uaenorth"
    subscriptionId    = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
  }
}

security_law_name                      = "law-sao-sec-eus-001"
security_law_rg                        = "rg-mgmt-sec-prd-sao-aen-001"


# Mgmt network peering resources
sourceVnetName      = "vnet-sao-mgmt-aen-001"
sourceVnetRg        = "rg-net-mgmt-prd-sao-aen-001"
destinationVnetName = "vnet-net-sao-conn-eus-001"
destinationVnetRg   = "rg-net-conn-prd-sao-aen-001"

mgmtNetworkPeering = {
  # peering with connectivity alz
  vnetpeering1 = {
    sourceVnetName      = "vnet-sao-mgmt-aen-001"
    sourceVnetRg        = "rg-net-mgmt-prd-sao-aen-001"
    destinationVnetName = "vnet-net-sao-conn-eus-001"
    destinationVnetRg   = "rg-net-conn-prd-sao-aen-001"
  }
}

# Mgmt DNS link
mgmtDNSLink = {
  link1 = {
    name                  = "mgmt-dns-link-01"
    resource_group_name   = "rg-dns-conn-prd-sao-aen-001"
    private_dns_zone_name = "privatelink.blob.core.windows.net"
    registration_enabled  = false
  }
  link2 = {
    name                  = "mgmt-dns-link-02"
    resource_group_name   = "rg-dns-conn-prd-sao-aen-001"
    private_dns_zone_name = "privatelink.vaultcore.azure.net"
    registration_enabled  = false
  }
}


backupVaultName = "mgmt-backupvault-01"

storagebackupPolicies = {
  "policy1" = {
    backup_policy_name               = "backuppolicy-conn-platform-blob01"
    backup_vault_Name                = "mgmt-backupvault-01"
    vault_default_retention_duration = "P30D"
    mgmt_sub_id                      = "60115b64-f08a-4207-bb4b-f8eb757aecd1"
    location                         = "uaenorth"
    backup_instance_name             = "blob-backup-instance-01"
    resource_group_name              = "rg-backup-mgmt-prd-sao-aen-001"
  }
}

automation_accounts = {
  account1 = {
    name                         = "mgmt-automationaccount-001"
    resource_group_name          = "rg-common-mgmt-prd-sao-aen-001"
    location                     = "uaenorth"
    sku                          = "Basic"
    local_authentication_enabled = true
  }
}

maintenance_configurations = {
  config1 = {
    maintenance_configuration_name = "mgmt-maintenance-config1"
    resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
    scope                          = "InGuestPatch" #"Host" is for the Isolated VMs
    visibility                     = "Custom"
    in_guest_user_patch_mode       = "User"
    start_date_time                = "2025-01-09 00:00" # "2025-01-09T01:00:00Z"
    expiration_date_time           = "2026-01-08 00:00" # "2026-01-08T23:59:59Z"
    duration                       = "03:00"            # HH:mm
    time_zone                      = "UTC"
    recur_every                    = "Week"
    linux_classifications          = ["Critical", "Security"]
    linux_excluded_packages        = ["package1", "package2"]
    linux_included_packages        = ["package3", "package4"]
    windows_classifications        = ["Critical", "Security"] # Fixed invalid values
    kb_numbers_to_exclude          = ["KB123456", "KB3654321"]
    kb_numbers_to_include          = ["KB111111", "KB222222"]
    reboot                         = "Always"
    tags                           = { environment = "dev" }
  }
}

dynamic_scope_maintenance = {
  dynamic_scope1 = {
    maintenance_configuration_name = "mgmt-maintenance-config1"
    dynamic_scope_maintenance_name = "mgmt-dynamic-scope1"
    resource_group_names           = ["rg-common-mgmt-prd-sao-aen-001"]
    resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
  }
}

vm_maintenance_assignments = {
  assignment1 = {
    maintenance_configuration_name = "mgmt-maintenance-config1"
    resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
    virtual_machine_id             = "/subscriptions/a03bd7fd-5bf3-4ea3-95be-7babd65eb73e/resourceGroups/rg-idnt-test-01/providers/Microsoft.Compute/virtualMachines/cvm-2019-01"
  }
  assignment2 = {
    maintenance_configuration_name = "mgmt-maintenance-config1"
    resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
    virtual_machine_id             = "/subscriptions/a03bd7fd-5bf3-4ea3-95be-7babd65eb73e/resourceGroups/rg-idnt-test-01/providers/Microsoft.Compute/virtualMachines/cvm-2019-02"
  }
  # assignment3 = {
  #   maintenance_configuration_name = "mgmt-maintenance-config1"
  #   resource_group_name            = "rg-common-mgmt-prd-sao-aen-001"
  #   virtual_machine_id             = "/subscriptions/7aa47d17-9de7-4605-a94f-3125b877f57d/resourceGroups/rg-paas-sao-sharedservices-aen-001/providers/Microsoft.Compute/virtualMachines/test-vm1"
  # }
}



diagnostic_logs = {
  "storage_account_1" = {
    name                           = "diag-setting-storage1"
    target_resource_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
    storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
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
  //   storage_account_id             = null
  //   log_analytics_workspace_id     = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  //   eventhub_name                  = null
  //   eventhub_authorization_rule_id = null
  //   logs_categories                = []
  //   metrics                        = ["AllMetrics"]
  // }
  # "kv_1" = {
  #   name                           = "diag-setting-kv1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "vnet" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "rsv" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "backupvault" = {
  #   name                           = "diag-setting-backupvault1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "bastion" = {
  #   name                           = "diag-setting-bastion1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-common-mgmt-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgmgmtsao010"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }
}




# ---------------------------------------------------------------------------------------------------------------- #

