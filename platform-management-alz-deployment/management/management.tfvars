# global variables
environment        = "dev"
mainLocation      = "southeastasia"
# resource group
resourceGroups = {
  netRG = {
    name     = "rg-net-mgmt-prd-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  },
  mgmtRG = {
    name     = "rg-mgmt-mgmt-prd-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  },
  commonRG = {
    name     = "rg-common-mgmt-prd-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  },
  backupRG = {
    name     = "rg-backup-mgmt-prd-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  }
}
# Mgmt User Assigned Identity
userAssignedIdentityName = {
  uai1 = {
    uai_name            = "uai-mgmt-sea-001"
    location            = "southeastasia"
    resource_group_name = "rg-common-mgmt-prd-sea-001"
  }
  uai2 = {
    uai_name            = "uai-mgmt-sea-002"
    location            = "southeastasia"
    resource_group_name = "rg-common-mgmt-prd-sea-001"
  }
}

# Mgmt Virtual network
mgmtVirtualNetworks = {
  vnet-mgmt-sea-001 = {
    resourceGroupName  = "rg-net-mgmt-prd-sea-001"
    subscriptionId     = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
    VirtualNetworkName = "vnet-mgmt-sea-001"
    address_space      = "192.168.0.0/23"
    sku_name           = "Standard"
  }
}

# Mgmt RT
mgmtRouteTables = {
  rt-mgmt-sea-001 = {
    resourceGroupName             = "rg-net-mgmt-prd-sea-001"
    routeTableName                = "rt-mgmt-sea-001"
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
  rt-mgmt-sea-002 = {
    resourceGroupName             = "rg-net-mgmt-prd-sea-001"
    routeTableName                = "rt-mgmt-sea-002"
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
  nsg-mgmt-sea-001 = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    name              = "nsg-mgmt-sea-001"
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
  vnet-mgmt-sea-001_gatewaysubnet = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    vnet_key          = "vnet-mgmt-sea-001"
    name              = "gatewaysubnet"
    addressPrefix     = "192.168.0.0/27"
    vnet_name         = "vnet-mgmt-sea-001"
  },
  vnet-mgmt-sea-001_AzureFirewallSubnet = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    vnet_key          = "vnet-mgmt-sea-001"
    name              = "AzureFirewallSubnet"
    addressPrefix     = "192.168.0.128/25"
    vnet_name         = "vnet-mgmt-sea-001"
  }
  vnet-mgmt-sea-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-01 = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    vnet_key          = "vnet-mgmt-sea-001"
    name              = "ksp-pcw-mgmt-platform-ci-vnet-01-snet-01"
    addressPrefix     = "192.168.1.0/26"
    vnet_name         = "vnet-mgmt-sea-001"
    subscriptionId    = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
    nsgName           = "nsg-mgmt-sea-001"
    rtName            = "rt-mgmt-sea-001"

  }
  vnet-mgmt-sea-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-02 = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    vnet_key          = "vnet-mgmt-sea-001"
    name              = "ksp-pcw-mgmt-platform-ci-vnet-01-snet-02"
    addressPrefix     = "192.168.1.64/26"
    vnet_name         = "vnet-mgmt-sea-001"
    subscriptionId    = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
    nsgName           = "nsg-mgmt-sea-001"
    rtName            = "rt-mgmt-sea-001"

  }
  vnet-mgmt-sea-001_ksp-pcw-mgmt-platform-ci-vnet-01-snet-02 = {
    resourceGroupName = "rg-net-mgmt-prd-sea-001"
    vnet_key          = "vnet-mgmt-sea-001"
    name              = "ksp-pcw-mgmt-platform-ci-vnet-01-snet-02"
    addressPrefix     = "192.168.1.64/26"
    vnet_name         = "vnet-mgmt-sea-001"
    subscriptionId    = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
    nsgName           = "nsg-mgmt-sea-001"
    rtName            = "rt-mgmt-sea-001"

  }
}

mgmtStorageAccounts = {
  sa1 = {
    name                      = "stmanagementseatest01"
    resource_group_name       = "rg-common-mgmt-sea-001"
    location                  = "southeastasia"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = false
  }
}


# Network Watcher [created automatically]
network_watcher_name              = "mgmtnetworkwatchersea001"
network_watcher_rg                = "NetworkWatcherRG"
private_endpoint_network_policies = "Disabled"





# ---------------------------------------------------------------------------------------------------------------- #

