# global variables
environment  = "dev"
mainLocation = "southeastasia"
tags = {
  environment = "sharedservices"
}
subscriptionId = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"

# resource group
resourceGroups = {
  netRG = {
    name     = "rg-net-sharedservices-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  },
  laRG = {
    name     = "rg-gov-sharedservices-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  }
  paasRG = {
    name     = "rg-paas-sharedservices-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  }
  backupRG = {
    name     = "rg-backup-sharedservices-sea-002"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  }
  secRG = {
    name     = "rg-sec-sharedservices-sea-001"
    location = "southeastasia"
    tags = {
      team = "Sec-Team"
    }
  }
}

#PaaS RG resources
# storage account
storageAccounts = {
  sa1 = {
    name                      = "stssharedseatest01"
    resource_group_name       = "rg-paas-sharedservices-sea-001"
    location                  = "southeastasia"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = false
  }
}

# Network Watcher [created automatically]
network_watcher_rg   = "NetworkWatcherRG"
network_watcher_name = "NetworkWatcher_southeastasia"


# virtual network
sharedservicesVirtualNetworks = {
  vnet1 = {
    resourceGroupName  = "rg-net-sharedservices-sea-001"
    subscriptionId     = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
    VirtualNetworkName = "vnet-sharedservices-sea-001"
    address_space      = "10.64.0.0/23"
    sku_name           = "Standard"
    location           = "southeastasia"
  }
}

sharedservicesSubnets = {
  Gatewaysubnet = {
    resourceGroupName      = "rg-net-sharedservices-sea-001"
    vnet_key               = "vnet1"
    name                   = "gatewaysubnet"
    addressPrefix          = "10.64.0.0/25"
    vnet_name              = "vnet-sharedservices-sea-001"
    networkSecurityGroupId = null
    routeTableName         = "rt-sharedservices-sea-001-1"
    subscriptionId         = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
  },
  AzureFirewallSubnet = {
    resourceGroupName      = "rg-net-sharedservices-sea-001"
    vnet_key               = "vnet1"
    name                   = "AzureFirewallSubnet"
    addressPrefix          = "10.64.0.128/25"
    vnet_name              = "vnet-sharedservices-sea-001"
    networkSecurityGroupId = null
    routeTableName         = "rt-sharedservices-sea-001-2"
    subscriptionId         = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
  }
  snet1 = {
    resourceGroupName      = "rg-net-sharedservices-sea-001"
    vnet_key               = "vnet1"
    name                   = "snet1-testing"
    addressPrefix          = "10.64.1.0/25"
    vnet_name              = "vnet-sharedservices-sea-001"
    networkSecurityGroupId = "nsg-sharedservices-sea-001"
    routeTableId           = null
    subscriptionId         = "3e3a2118-a39a-4ff7-9df7-104c3e1e611a"
  }
}

sharedservicesuan = "ual-sharedservices-sea-001"
###-----------------------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------
