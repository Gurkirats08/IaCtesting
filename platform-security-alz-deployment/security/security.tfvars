# global variables
environment = "dev"

#uan
securityuan = "ua-sec-identity"
subscriptionId = "dac03557-6089-4127-ae8a-e343e5635de2"

# resource group
resourceGroups = {
  netRG = {
    name     = "rg-net-sec-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  secRG = {
    name     = "rg-sec-sec-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  mgmtRG = {
    name     = "rg-mgmt-sec-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  commonRG = {
    name     = "rg-common-sec-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  backupRG = {
    name     = "rg-backup-sec-prd-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  },
  lawRG = {
    name     = "rg-sec-law-sao-aen-001"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    } 
  }
}

securityResourceLocks = {
  "lock1" = {
    name                = "lock-sao-security-aen-001"
    lock_level          = "CanNotDelete"
    notes               = "Lock to prevent accidental deletion"
    resource_group_name = "rg-backup-sec-prd-sao-aen-001"
  }
}



# Network Watcher [created automatically]
network_watcher_rg   = "NetworkWatcherRG"
network_watcher_name = "NetworkWatcher_uaenorth"


# storage account
storageAccounts = {
  stg1 = {
    name                      = "stgsecurity001"
    resource_group_name       = "rg-common-sec-prd-sao-aen-001"
    location                  = "uaenorth"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = false
  }
  stg2 = {
    name                      = "stgsecurity002"
    resource_group_name       = "rg-common-sec-prd-sao-aen-001"
    location                  = "uaenorth"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = false
  }
}

mainLocation = "uaenorth"

# sec_keyvault_module
secKeyVaults = {
  kv1 = {
    name     = "kv-sec-sao-aen-3"
    location = "uaenorth"
    sku      = "premium"
  }
}

#ddos
SecurityDDos = {
  ddos1 = {
    name              = "ddos-net-sao-sec-aen-001"
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
  }
}

# virtual network
secVirtualNetworks = {
  vnet-sao-sec-aen-001 = {
    resourceGroupName  = "rg-net-sec-prd-sao-aen-001"
    subscriptionId     = "dac03557-6089-4127-ae8a-e343e5635de2"
    VirtualNetworkName = "vnet-sao-sec-aen-001"
    address_space      = "172.29.4.0/23"
    bastionIPName      = "bastion-ip-sao-sec-aen-001"
    sku_name           = "Standard"
    bastionName        = "bastion-sao-sec-aen-001"
    DDosProtectionPlan = "ddos-net-sao-sec-aen-001"
  }
}

secRouteTables = {
  rt-sao-sec-aen-001-1 = {
    resourceGroupName         = "rg-net-sec-prd-sao-aen-001"
    routeTableName            = "rt-sao-sec-aen-001-1"
    enableBgpRoutePropagation = false
    routes = [{
      name             = "ksp-pcw-sec-platform-ci-route-01"
      addressPrefix    = "172.29.4.32/27"
      NextHopIpAddress = "172.29.0.132"
      nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-sec-platform-ci-route-02"
        addressPrefix    = "172.29.4.128/25"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-sec-platform-ci-route-03"
        addressPrefix    = "172.29.4.64/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "ksp-pcw-sec-platform-ci-route-04"
        addressPrefix    = "172.29.5.0/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      }
    ]
  }
  rt-sao-sec-aen-001-2 = {
    resourceGroupName         = "rg-net-sec-prd-sao-aen-001"
    routeTableName            = "rt-sao-sec-aen-001-2"
    enableBgpRoutePropagation = false
    routes = [{
      name          = "ksp-pcw-sec-platform-ci-route-01"
      addressPrefix = "0.0.0.0/0"
      nextHopType   = "Internet"
    }]
  }
}


secNetworkSecurityGroups = {
  nsg-sao-sec-aen-001 = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    name              = "nsg-sao-sec-aen-001"
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
  },
  nsg-sao-sec-bas-001 = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    name              = "nsg-sao-sec-bas-001"
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

secSubnets = {
  vnet-sao-sec-aen-001_gatewaysubnet = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    vnet_key          = "vnet-sao-sec-aen-001"
    name              = "gatewaysubnet"
    addressPrefix     = "172.29.4.32/27"
    vnet_name         = "vnet-sao-sec-aen-001"
    routeTableId      = null
  },
  vnet-sao-sec-aen-001_AzureFirewallSubnet = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    vnet_key          = "vnet-sao-sec-aen-001"
    name              = "AzureFirewallSubnet"
    addressPrefix     = "172.29.4.128/25"
    vnet_name         = "vnet-sao-sec-aen-001"
    routeTableId      = null
  }
  vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01 = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    vnet_key          = "vnet-sao-sec-aen-001"
    name              = "ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    addressPrefix     = "172.29.4.64/26"
    vnet_name         = "vnet-sao-sec-aen-001"
    subscriptionId    = "dac03557-6089-4127-ae8a-e343e5635de2"
    nsgName           = "nsg-sao-sec-aen-001"
    routeTableId      = null
  }
  vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-02 = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    vnet_key          = "vnet-sao-sec-aen-001"
    name              = "ksp-pcw-sec-platform-ci-vnet-01-snet-02"
    addressPrefix     = "172.29.5.0/26"
    vnet_name         = "vnet-sao-sec-aen-001"
    subscriptionId    = "dac03557-6089-4127-ae8a-e343e5635de2"
    nsgName           = "nsg-sao-sec-aen-001"
    routeTableId      = null
  }
  vnet-sao-sec-aen-001_AzureBastionSubnet = {
    resourceGroupName = "rg-net-sec-prd-sao-aen-001"
    vnet_key          = "vnet-sao-sec-aen-001"
    name              = "AzureBastionSubnet"
    addressPrefix     = "172.29.5.64/26"
    vnet_name         = "vnet-sao-sec-aen-001"
    subscriptionId    = "dac03557-6089-4127-ae8a-e343e5635de2"
    nsgName           = "nsg-sao-sec-bas-001"
    routeTableId      = null
  }
}

secJumpBoxVms = {
  vmjumpsec01 = {
    vmName                     = "vmjumpsec01"
    resourceGroupName          = "rg-common-sec-prd-sao-aen-001"
    subscriptionId             = "dac03557-6089-4127-ae8a-e343e5635de2"
    computerName               = "vmjumpsec01"
    osType                     = "Windows"
    vmSize                     = "Standard_DC4ads_v5"
    imagePublisher             = "MicrosoftWindowsServer"
    imageOffer                 = "WindowsServer"
    imageSku                   = "2022-datacenter-azure-edition-hotpatch"
    imageVersion               = "latest"
    createOption               = "FromImage"
    diskSizeGB                 = 127
    vmDiskStorageType          = "Standard_LRS"
    vmNicSuffix                = "-nic-01"
    nsgName                    = "nsg-sao-sec-aen-001"
    ipConfigName               = "ipconfig2"
    privateIPAllocationMethod  = "Static"
    jumpBoxPrivateIP           = "172.29.4.98"
    vNetName                   = "vnet-sao-sec-aen-001"
    subnetName                 = "ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    availabilityZone           = 3
    encryptionAtHost           = false
    diskEncryptionKeyVaultName = ""
    subnetresourceGroupName    = "rg-net-sec-prd-sao-aen-001"
  }
}
adminUser = "adminuser"


secPrivateEndpoint = {
  pe-kv-aen-001 = {
    private_endpoint_name          = "pe-kv-sec-aen-001"
    resource_group_name            = "rg-sec-sec-prd-sao-aen-001"
    subresource_names              = ["vault"]
    private_dns_zone_id            = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
    subnet_id                      = "vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    private_connection_resource_id = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-sec-sec-prd-sao-aen-001/providers/Microsoft.KeyVault/vaults/kv-sec-sao-aen-3"
  }

  pe-sa-aen-001 = {
    private_endpoint_name          = "pe-sa-sec-aen-001"
    resource_group_name            = "rg-sec-sec-prd-sao-aen-001"
    subnet_id                      = "vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    private_dns_zone_id            = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_connection_resource_id = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
    subresource_names              = ["blob"]
  }

  "pe3" = {
    private_endpoint_name          = "pe-sao-sec-aen-001-tfstorage"
    resource_group_name            = "rg-devops-sec-sao-aen-001"
    private_dns_zone_id            = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    subnet_id                      = "vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    private_connection_resource_id = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-devops-sec-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stsaosecdevopsaen020"
    subresource_names              = ["blob"]
  }
}


secDiskEncryptionSet = {
  sec-team = {
    resourceGroupName        = "rg-common-sec-prd-sao-aen-001"
    disk_encryption_set_name = "sec-team"
  }
}



# Storage Account Data Block 
# storageAccountResourceGroupName = "rgsfstac001"
# storageAccountName              = "stsfstac001"

secWorkspace = {
  law1 = {
    name                     = "law-sao-sec-eus-001"
    resourceGroupName        = "rg-sec-law-sao-aen-001"
    sku                      = "PerGB2018"
    retentionPeriod          = 30
    internetIngestionEnabled = false
    internetQueryEnabled     = false
    dailyQuotaGb             = 100
  }
}

secRbacs = {
  kv = {
    resource_name        = "kv-sec-sao-aen-3"
    role_definition_name = "Key Vault Reader"
    subscriptionId       = "dac03557-6089-4127-ae8a-e343e5635de2"
    provider             = "Microsoft.KeyVault"
    resource_type        = "vaults"
  }
}

secVnetPeering = {
  vnetpeering1 = {

    sourceVnetName      = "vnet-sao-sec-aen-001"
    sourceVnetRg        = "rg-net-sec-prd-sao-aen-001"
    destinationVnetName = "vnet-net-sao-conn-eus-001"
    destinationVnetRg   = "rg-net-conn-prd-sao-aen-001"
  }
}

secDNSLink = {
  vaultDns1 = {
    name                  = "sec-dns-link-001"
    resource_group_name   = "rg-dns-conn-prd-sao-aen-001"
    private_dns_zone_name = "privatelink.blob.core.windows.net"
    registration_enabled  = false
  }
  vaultDns2 = {
    name                  = "sec-dns-link-002"
    resource_group_name   = "rg-dns-conn-prd-sao-aen-001"
    private_dns_zone_name = "privatelink.vaultcore.azure.net"
    registration_enabled  = false
  }


}

sourceVnetName      = "vnet-sao-sec-aen-001"
sourceVnetRg        = "rg-net-sec-prd-sao-aen-001"
destinationVnetName = "Contos-ADO-Runners-vnet"
destinationVnetRg   = "Contos-ADO-Runners"




# Hardware Security Module (HSM)

connHSM = {
  name                = "Sec-hsm01"
  resource_group_name = "rg-sec-hsm-sao-aen-001"
}

subscriptionId                         = "dac03557-6089-4127-ae8a-e343e5635de2"
nsgFlowstorageAccountResourceGroupName = "rg-common-sec-prd-sao-aen-001"
nsgFlowstorageAccountName              = "stgsecurity001"
des_name                               = "sec-team"





backupVaultName = "secbackupvault-001"

storagebackupPolicies = {
  "policy1" = {
    backup_policy_name               = "backuppolicy-sec-platform-blob01"
    backup_vault_Name                = "appbackupvault-001"
    vault_default_retention_duration = "P30D"
    app_sub_id                       = "dac03557-6089-4127-ae8a-e343e5635de2"
    location                         = "uaenorth"
    backup_instance_name             = "blob-backup-instance-01"
    resource_group_name              = "rg-backup-sec-prd-sao-aen-001"
  }
}

diskBackupPolicies = {
  "disk_policy1" = {
    backup_policy_name               = "backuppolicy-disk01"
    backup_vault_Name                = "secbackupvault-001"
    subscriptionId                   = "dac03557-6089-4127-ae8a-e343e5635de2"
    location                         = "uaenorth"
    backup_instance_name             = "disk-backup-instance-01"
    backupvault_resource_group_name  = "rg-backup-sec-prd-sao-aen-001"
    vmName                           = "vmjumpsec01"               // vm name where disk is attached to
    osType                           = "Windows"                    // os type of the vm where disk is attached to
    managed_disk_resource_group_name = "rg-common-sec-prd-sao-aen-001" // rg of the vm where disk is attached to
    snapshot_resource_group_name     = "rg-backup-sec-prd-sao-aen-001"

  }
}

hsm_key_name       = "hsm-key-sec-002"
key_vault_key_name = "kv-key-sec-081"
hsm_name





# # # Mgmt nsg flow log
connFlowLog = {
  nsg_flow_log_name = "flow-log-sao-sec-aen-001"
  location          = "uaenorth"
  nsgId             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-net-sec-prd-sao-aen-001/providers/Microsoft.Network/networkSecurityGroups/nsg-sao-sec-aen-001"
}


securitydatacollectionendpoint = {
  "endpoint1" = {
    datacollectionendpoint = "endpoint--sao-sec-aen-001"
    resource_group_name    = "rg-mgmt-sec-prd-sao-aen-001"
    location               = "uaenorth"
    kind                   = "Windows"

  }
  "endpoint2" = {
    datacollectionendpoint = "endpoint--sao-sec-aen-002"
    resource_group_name    = "rg-mgmt-sec-prd-sao-aen-001"
    location               = "uaenorth"
    kind                   = "Linux"

  }
}

dce_resource_association = {
  "dce_resource1_windows" = {
    target_resource_id     = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Compute/virtualMachines/vmjumpsec01"
    datacollectionendpoint = "endpoint--sao-sec-aen-001"
  }
}

dcr_configs = {
  dcr1 = {
    dcr_name                 = "dcr-windows-ssrc-aen-001"
    dcr_rg_name              = "rg-mgmt-sec-prd-sao-aen-001"
    dcr_rg_location          = "uaenorth"
    dce_name                 = "endpoint--sao-sec-aen-001"
    dce_rg_name              = "rg-mgmt-sec-prd-sao-aen-001"
    destination_logworkspace = "law-sao-sec-eus-001"
    data_flow_streams        = ["Microsoft-InsightsMetrics", "Microsoft-Event"]

    # Windows-specific data sources
    os_type                          = "windows"
    datasource_perfcounter           = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
    datasource_perfCounterSpecifiers = ["Processor(*)\\% Processor Time"]
    win_perfcounter_name             = "datasource-perfcounter-01"
    win_event_log_stream             = ["Microsoft-WindowsEvent"]
    win_path_Query                   = ["*![System/Level=1]"]
    win_log_name                     = "windows-log"

    # Linux-specific data sources
    linux_log_name         = ""
    linux_event_log_stream = []

  }

  dcr2 = {
    dcr_name                 = "dcr-linux-ssrc-aen-001"
    dcr_rg_name              = "rg-mgmt-sec-prd-sao-aen-001"
    dcr_rg_location          = "uaenorth"
    dce_name                 = "endpoint--sao-sec-aen-002"
    dce_rg_name              = "rg-mgmt-sec-prd-sao-aen-001"
    destination_logworkspace = "law-sao-sec-eus-001"
    data_flow_streams        = ["Microsoft-InsightsMetrics"]

    # Windows-specific data sources
    os_type                          = "linux"
    datasource_perfcounter           = []
    datasource_perfCounterSpecifiers = []
    win_perfcounter_name             = ""
    win_event_log_stream             = []
    win_path_Query                   = []
    win_log_name                     = ""

    # Linux-specific data sources
    linux_log_name         = "linux-log"
    linux_event_log_stream = ["Microsoft-Syslog"]

  }
}


secRecoveryServiceVault = {
  rsv1 = {
    recovery_services_vault_name = "rsv-sao-sec-aen-001"
    resource_group_name          = "rg-backup-sec-prd-sao-aen-001"
    location                     = "uaenorth"
    sku                          = "Standard"
    identity_type                = "UserAssigned"
  }
}

rsv_rg = "rg-backup-sec-prd-sao-aen-001"

hsmPrivateEndpoint = {
  "hsm-pe" = {
    private_endpoint_name          = "pe-sao-sec-aen-001-hsm"
    resource_group_name            = "rg-sec-hsm-sao-aen-001"
    location                       = "uaenorth"
    subnet_id                      = "vnet-sao-sec-aen-001_ksp-pcw-sec-platform-ci-vnet-01-snet-01"
    private_connection_resource_id = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-sec-hsm-sao-aen-001/providers/Microsoft.KeyVault/managedHSMs/Sec-hsm01"
    private_dns_zone_id            = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-dns-conn-prd-sao-aen-001/providers/Microsoft.Network/privateDnsZones/privatelink.managedhsm.azure.net"
    subresource_names              = ["managedhsm"]

  }
}

vm_backup_policies = {
  policy1 = {
    backup_policy_name      = "vm-backup-policy-01"
    recovery_vault_name     = "rsv-sao-sec-aen-001"
    rsv_resource_group_name = "rg-backup-sec-prd-sao-aen-001"
    backup_frequency        = "Daily"
    backup_time             = "23:00"
    retention_daily_count   = 10
    vm_name                 = "vmjumpsec01"
    vm_resource_group_name  = "rg-common-sec-prd-sao-aen-001"
  }
}

diagnostic_logs = {
  "storage_account_1" = {
    name                           = "diag-setting-storage1"
    target_resource_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
    storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
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
  //   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  //   log_analytics_workspace_id     = "/subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  //   eventhub_name                  = null
  //   eventhub_authorization_rule_id = null
  //   logs_categories                = []
  //   metrics                        = ["AllMetrics"]
  // }
  # "kv_1" = {
  #   name                           = "diag-setting-kv1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "vnet" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }

  # "rsv" = {
  #   name                           = "diag-setting-vnet1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "backupvault" = {
  #   name                           = "diag-setting-backupvault1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["Health"]
  # }

  # "bastion" = {
  #   name                           = "diag-setting-bastion1"
  #   target_resource_id             = "xxx"
  #   storage_account_id             = "/subscriptions/dac03557-6089-4127-ae8a-e343e5635de2/resourceGroups/rg-common-sec-prd-sao-aen-001/providers/Microsoft.Storage/storageAccounts/stgsecurity001"
  #   log_analytics_workspace_id     = "subscriptions/60115b64-f08a-4207-bb4b-f8eb757aecd1/resourceGroups/rg-mgmt-mgmt-prd-sao-aen-001/providers/Microsoft.OperationalInsights/workspaces/law-sao-mgmt-ops-aen-001"
  #   eventhub_name                  = null
  #   eventhub_authorization_rule_id = null
  #   logs_categories                = []
  #   metrics                        = ["AllMetrics"]
  # }
}





