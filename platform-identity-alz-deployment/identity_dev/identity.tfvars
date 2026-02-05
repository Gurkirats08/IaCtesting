#Global Variables

environment             = "dev"
location                = "uaenorth"
identity_sub_id         = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
security_subsId         = "dac03557-6089-4127-ae8a-e343e5635de2"
terraformStorageRG      = "rg-devops-phi-idnt-test"
terraformStorageAccount = "stphiidntdevopstest"
hsmKeyName              = "idnt-hsm-key-test1"
tags                    = { env = "dev", team = "sec-Team" }

## RG's
resourceGroups = {

  # netRG = {
  #   name     = "rg-net-idnt-prd-phi-sea-001"
  #   location = "uaenorth"
  #   tags = {
  #     team = "Sec-Team"
  #   }
  # },
  # addsRG = {
  #   name     = "rg-idnt-test-01"
  #   location = "uaenorth"
  #   tags = {
  #     team = "Sec-Team"
  #   }
  # }
  # commonRG = {
  #   name     = "rg-common-idnt-prd-phi-sea-001"
  #   location = "uaenorth"
  #   tags = {
  #     team = "Sec-Team"
  #   }
  # }
  addsRG = {
    name     = "rg-idnt-test-31"
    location = "uaenorth"
    tags = {
      team = "Sec-Team"
    }
  }
}

#linux VM Ubuntu
sharedservicesLinuxVms = {
  linux-vm1 = {
    vmName                    = "rhel-vm-01"
    resourceGroupName         = "rg-idnt-test-31"
    subscriptionId            = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
    osType                    = "Linux"
    vmSize                    = "Standard_DC4ads_v5"
    imagePublisher            = "redhat"
    imageOffer                = "rhel-cvm"
    imageSku                  = "9_4_cvm"
    imageVersion              = "latest"
    createOption              = "FromImage"
    diskSizeGB                = 127
    vmDiskStorageType         = "Standard_LRS"
    nsgName                   = "nsg-idnt-platform-dev-01"
    ipConfigName              = "ipconfig1"
    # privateIPAllocationMethod = "Static"
    # jumpBoxPrivateIP          = "10.64.1.96"
    # vNetName                  = "vnet-phi-sharedservices-sea-001"
    # subnetName                = "ksp-pcw-sharedservices-platform-ci-vnet-01-snet-01"
    # subnetresourceGroupName   = "rg-net-phi-sharedservices-sea-001"
    # availabilityZone          = 3
    # encryptionAtHost          = false
    # vmNicSuffix               = "-linuxnic-01"

    subnetName                = "snet-idnt-platform-dev-01"
    subnetresourceGroupName   = "rg-net-idnt-prd-phi-sea-001"
    vNetName                  = "vnet-idnt-platform-dev-01"
    resourceGroupName         = "rg-adds-idnt-prd-phi-sea-001"
    privateIPAllocationMethod = "Dynamic"
    vmNicSuffix               = "-nic-01"
    ipConfigName              = "ipconfig2"
    privateIPAllocationMethod = "Dynamic"
    jumpBoxPrivateIP           = "172.29.2.6"
    availabilityZone           = 3
    encryptionAtHost           = true
    diskEncryptionKeyVaultName = ""
  }
}

# vm_backup_policies = {
#   policy1 = {
#     backup_policy_name      = "vm-backup-policy-01"
#     recovery_vault_name     = "rsv-phi-shared-sea-001"
#     rsv_resource_group_name = "rg-backup-phi-sharedservices-sea-001"
#     backup_frequency        = "Daily"
#     backup_time             = "23:00"
#     retention_daily_count   = 10
#     vm_name                 = "vmjumpshareds01"
#     vm_resource_group_name  = "rg-devops-sharedservices-phi-sea-001"
#   }
# }

managedIdentity = "ua-noncvm-test-01"

adminUser = "adminuser"
#non cvm
identityVirtualMachines = {
  windows-vm01 = {
    vmName                     = "idnt-noncvm-01"
    computerName               = "idnt-noncvm-01"
    subscriptionId             = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
    osType                     = "Windows"
    vmSize                     = "Standard_D2s_v3"
    imagePublisher             = "MicrosoftWindowsServer"
    imageOffer                 = "WindowsServer"
    imageSku                   = "2022-Datacenter-azure-edition" // latest image
    imageVersion               = "latest"
    createOption               = "FromImage"
    diskSizeGB                 = 127
    vmDiskStorageType          = "Standard_LRS"
    subnetName                 = "snet-idnt-platform-dev-01"
    vNetName                   = "vnet-idnt-platform-dev-01"
    subnetresourceGroupName    = "rg-net-idnt-prd-phi-sea-001"
    resourceGroupName          = "rg-idnt-test-01"
    privateIPAllocationMethod  = "Dynamic"
    vmNicSuffix                = "-nic-01"
    ipConfigName               = "ipconfig2"
    diskEncryptionKeyVaultName = ""
    availabilityZone           = 3
    encryptionAtHost           = true
  }
}


#cvm
# identityVirtualMachines = {
#   windows-vm03 = {
#     vmName                    = "cvm-2019-01"
#     computerName              = "cvm-2019-01"
#     osType                    = "Windows"
#     vmSize                    = "Standard_DC4ads_v5"
#     imagePublisher            = "MicrosoftWindowsServer"
#     imageOffer                = "WindowsServer"
#     subscriptionId            = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     imageSku                  = "2019-datacenter-gensecond"
#     imageVersion              = "latest"
#     createOption              = "FromImage"
#     diskSizeGB                = 127
#     vmDiskStorageType         = "StandardSSD_ZRS"
#     subnetName                = "snet-idnt-platform-dev-01"
#     subnetresourceGroupName   = "rg-net-idnt-prd-phi-sea-001"
#     vNetName                  = "vnet-idnt-platform-dev-01"
#     resourceGroupName         = "rg-idnt-test-01"
#     privateIPAllocationMethod = "Dynamic"
#     vmNicSuffix               = "-nic-01"
#     ipConfigName              = "ipconfig2"
#     privateIPAllocationMethod = "Dynamic"
#     # jumpBoxPrivateIP           = "172.29.2.6"
#     availabilityZone           = 3
#     encryptionAtHost           = true
#     diskEncryptionKeyVaultName = ""
#   }
#   windows-vm04 = {
#     vmName                    = "cvm-2019-02"
#     computerName              = "cvm-2019-02"
#     osType                    = "Windows"
#     vmSize                    = "Standard_DC4ads_v5"
#     imagePublisher            = "MicrosoftWindowsServer"
#     imageOffer                = "WindowsServer"
#     subscriptionId            = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     imageSku                  = "2019-datacenter-gensecond"
#     imageVersion              = "latest"
#     createOption              = "FromImage"
#     diskSizeGB                = 127
#     vmDiskStorageType         = "StandardSSD_ZRS"
#     subnetName                = "snet-idnt-platform-dev-01"
#     subnetresourceGroupName   = "rg-net-idnt-prd-phi-sea-001"
#     vNetName                  = "vnet-idnt-platform-dev-01"
#     resourceGroupName         = "rg-idnt-test-01"
#     privateIPAllocationMethod = "Dynamic"
#     vmNicSuffix               = "-nic-01"
#     ipConfigName              = "ipconfig2"
#     privateIPAllocationMethod = "Dynamic"
#     # jumpBoxPrivateIP           = "172.29.2.6"
#     availabilityZone           = 3
#     encryptionAtHost           = true
#     diskEncryptionKeyVaultName = ""
#   }
# }

# #linux VM Ubuntu
# sharedservicesLinuxVms = {
#   linux-vm1 = {
#     vmName                    = "linux-vm1"
#     resourceGroupName         = "rg-idnt-test-01"
#     subscriptionId            = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     osType                    = "Linux"
#     vmSize                    = "Standard_DC4ads_v5"
#     imagePublisher            = "Canonical"
#     imageOffer                = "ubuntu-24_04-lts"
#     imageSku                  = "cvm"
#     imageVersion              = "latest"
#     createOption              = "FromImage"
#     diskSizeGB                = 127
#     vmDiskStorageType         = "Standard_LRS"
#     //nsgName                   = ""
#     ipConfigName              = "ipconfig1"
#     privateIPAllocationMethod = "Dynamic"
#     //jumpBoxPrivateIP          = "10.64.1.96"
#     subnetName                = "snet-idnt-platform-dev-01"
#     subnetresourceGroupName   = "rg-net-idnt-prd-phi-sea-001"
#     vNetName                  = "vnet-idnt-platform-dev-01"
#     availabilityZone          = 3
#     encryptionAtHost          = false
#     vmNicSuffix               = "-linuxnic-01"
#   },
#   linux-vm2 = {
#     vmName                    = "linux-vm2"
#     resourceGroupName         = "rg-idnt-test-01"
#     subscriptionId            = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     osType                    = "Linux"
#     vmSize                    = "Standard_DC4ads_v5"
#     imagePublisher            = "Canonical"
#     imageOffer                = "ubuntu-24_04-lts"
#     imageSku                  = "cvm"
#     imageVersion              = "latest"
#     createOption              = "FromImage"
#     diskSizeGB                = 127
#     vmDiskStorageType         = "Standard_LRS"
#     //nsgName                   = "nsg-phi-sharedservices-sea-001"
#     ipConfigName              = "ipconfig1"
#     privateIPAllocationMethod = "Dynamic"
#     //jumpBoxPrivateIP          = "10.64.1.97"
#     subnetName                = "snet-idnt-platform-dev-01"
#     subnetresourceGroupName   = "rg-net-idnt-prd-phi-sea-001"
#     vNetName                  = "vnet-idnt-platform-dev-01"
#     availabilityZone          = 3
#     encryptionAtHost          = false
#     vmNicSuffix               = "-linuxnic-02"
#   }

# }

resource_group_name = "rg-idnt-test-23"
subscriptionId      = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"

hsm_name                 = "Sec-hsm01"
hsm_resource_group       = "rg-sec-hsm-phi-sea-001"
hsm_key_name             = "hsm-key-copy01"
disk_encryption_set_name = "sec-team"

backup_vault_name = "testbackupvault-001"


appDataDisks = {
  "disk1" = {
    resource_group_name  = "rg-idnt-test-23"
    disk_name            = "app-data-disk-23"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
    lun                  = 0
    caching              = "ReadWrite"
  }
}

# appRecoveryServiceVault = {
#   rsv1 = {
#     recovery_services_vault_name = "rsv-phi-test-sea-001"
#     resource_group_name          = "rg-idnt-test-01"
#     location                     = "uaenorth"
#     sku                          = "Standard"
#     identity_type                = "UserAssigned"
#   }
# }


## Update Manager ##
maintenance_configurations = {
  config1 = {
    maintenance_configuration_name = "iac-maintenance-config1"
    resource_group_name            = "rg-idnt-test-01"
    scope                          = "InGuestPatch" #"Host" is for the Isolated VMs
    visibility                     = "Custom"
    in_guest_user_patch_mode       = "User"
    start_date_time                = "2025-01-28 00:00" # "2025-01-09T01:00:00Z"
    expiration_date_time           = "2026-01-27 00:00" # "2026-01-08T23:59:59Z"
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
    maintenance_configuration_name = "iac-maintenance-config1"
    dynamic_scope_maintenance_name = "test-dynamic-scope1"
    resource_group_names           = ["rg-idnt-test-01"]
    resource_group_name            = "rg-idnt-test-01"
  }
}


vm_maintenance_assignments = {
  assignment1 = {
    maintenance_configuration_name = "iac-maintenance-config1"
    resource_group_name            = "rg-idnt-test-01"
    vm_name                        = "cvm-test04"
    vm_resource_group_name         = "rg-idnt-test-01"
  }
}

mainLocation = "uaenorth"

vm_backup_policies = {
  policy1 = {
    backup_policy_name      = "vm-backup-policy-31"
    recovery_vault_name     = "rsv-phi-idnt-test-31"
    rsv_resource_group_name = "rg-idnt-test-31"
    backup_frequency        = "Daily"
    backup_time             = "23:00"
    retention_daily_count   = 10
    vm_name                 = "idntvm-DC01"
    vm_resource_group_name  = "rg-adds-idnt-prd-phi-sea-001"
  }
  policy2 = {
    backup_policy_name      = "vm-backup-policy-32"
    recovery_vault_name     = "rsv-phi-idnt-test-31"
    rsv_resource_group_name = "rg-idnt-test-31"
    backup_frequency        = "Daily"
    backup_time             = "23:00"
    retention_daily_count   = 10
    vm_name                 = "idntvm-DC02"
    vm_resource_group_name  = "rg-adds-idnt-prd-phi-sea-001"
  }
}


appRecoveryServiceVault = {
  rsv1 = {
    recovery_services_vault_name = "rsv-phi-idnt-test-31"
    resource_group_name          = "rg-idnt-test-31"
    location                     = "uaenorth"
    sku                          = "Standard"
    identity_type                = "UserAssigned"
  }
}

rsv_rg = "rg-idnt-test-31"


#Network resources

virtual_network    = "vnet-idnt-platform-dev-01"
vnet_address_space = "172.29.2.0/23"

#route-table 

identityRouteTables = {
  rt1 = {
    resourceGroupName          = "rg-net-idnt-prd-phi-sea-001"
    routeTableName             = "rt-idnt-platform-dev-01"
    disableBgpRoutePropagation = true
    routes = [
      {
        name             = "udr-idnt-platform-01"
        addressPrefix    = "172.29.1.0/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      },
      {
        name             = "udr-idnt-platform-02"
        addressPrefix    = "172.29.2.0/26"
        NextHopIpAddress = "172.29.0.132"
        nextHopType      = "VirtualAppliance"
      }
    ]
  }
  rt2 = {
    resourceGroupName          = "rg-net-idnt-prd-phi-sea-001"
    routeTableName             = "rt-idnt-platform-dev-02"
    disableBgpRoutePropagation = true
    routes = [{
      name          = "udr-idnt-platform-internet"
      addressPrefix = "0.0.0.0/0"
      nextHopType   = "Internet"
    }]
  }
}

# virtual network
idntVirtualNetworks = {
  vnet1 = {
    resourceGroupName  = "rg-net-idnt-prd-phi-sea-001"
    subscriptionId     = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
    VirtualNetworkName = "vnet-idnt-platform-dev-01"
    address_space      = "172.29.2.0/23"
    bastionIPName      = ""
    sku_name           = "Standard"
    bastionName        = ""
    # DDosProtectionPlan = "ddos-phi-conn-eus-017"
  }
}


#nsg

identityNetworkSecurityGroups = {
  nsg1 = {
    name              = "nsg-idnt-platform-dev-01"
    resourceGroupName = "rg-net-idnt-prd-phi-sea-001"
    securityRules = [
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


#SNET 

idntSubnets = {
  snet1 = {
    resourceGroupName = "rg-net-idnt-prd-phi-sea-001"
    vnet_key          = "vnet-idnt-platform-dev-01"
    name              = "snet-idnt-platform-dev-01"
    addressPrefix     = "172.29.2.0/26"
    vnet_name         = "vnet-idnt-platform-dev-01"
    routeTableId      = null
    subscriptionId    = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
    # nsgName           = "nsg-idnt-platform-dev-01"
    #  nsgName           = null
  },
  snet2 = {
    resourceGroupName = "rg-net-idnt-prd-phi-sea-001"
    vnet_key          = "vnet-idnt-platform-dev-01"
    name              = "snet-idnt-platform-dev-02"
    addressPrefix     = "172.29.2.64/26"
    vnet_name         = "vnet-idnt-platform-dev-01"
    routeTableId      = null
    subscriptionId    = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
    # nsgName           = null
  }
}

identityNetworkPeering = {
  # peering with connectivity alz
  vnetpeering1 = {
    sourceVnetName      = "vnet-idnt-platform-dev-01"
    sourceVnetRg        = "rg-net-idnt-prd-phi-sea-001"
    destinationVnetName = "vnet-net-phi-conn-eus-001"
    destinationVnetRg   = "rg-net-conn-prd-phi-sea-001"
  }
}

idntPrivateEndpoint = {
  #PE for storage account created by terraform code
  "pe1" = {
    private_endpoint_name = "pe-idnt-platform-001-storage"
    subnet_name           = "snet-idnt-platform-dev-01"
    vnet_name             = "vnet-idnt-platform-dev-01"
    storage_account_id    = "/subscriptions/a03bd7fd-5bf3-4ea3-95be-7babd65eb73e/resourceGroups/rg-common-idnt-prd-phi-sea-001/providers/Microsoft.Storage/storageAccounts/stgnsgflowidntdev02"
    subresource_names     = ["blob"]
  },
  # PE for backend storage to store TF state files
  "pe2" = {
    private_endpoint_name = "pe-idnt-platform-002-storage"
    subnet_name           = "snet-idnt-platform-dev-01"
    vnet_name             = "vnet-idnt-platform-dev-01"
    storage_account_id    = "/subscriptions/a03bd7fd-5bf3-4ea3-95be-7babd65eb73e/resourceGroups/rg-devops-phi-idnt-eus-003/providers/Microsoft.Storage/storageAccounts/stphiidntdevopseus003"
    subresource_names     = ["blob"]
  }
}


# resource_group = "rg-idnt-platform-dev-01"

# hsm_name                  = "Sec-hsm01"
# hsm_resource_group        = "rg-sec-hsm-phi-sea-001"
# hsm_key_name              = "idnt-hsm-key-01"
nsgFlowStorageAccountName = "stgnsgflowidntdev02"
# terraformStorageRG          = "rg-devops-phi-idnt-eus-003"
# terraformStorageAccount     = "stphiidntdevopseus003"
# disk_encryption_set_name    = "sec-team"
private_dns_zone_name       = "privatelink.vaultcore.azure.net"
dnszone_resource_group_name = "rg-dns-conn-prd-phi-sea-001"

# Network Watcher [created automatically]
network_watcher_rg   = "NetworkWatcherRG"
network_watcher_name = "NetworkWatcher_uaenorth"

identity_user_assigned_identity_name = "idnt-platform-identity-UAI"

# VM

# adminUser = "adminuser"

# identityVirtualMachines = {
#   windows-vm01 = {
#     vmName                     = "idnt-noncvm-01"
#     computerName               = "idnt-noncvm-01"
#     subscriptionId             = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     osType                     = "Windows"
#     vmSize                     = "Standard_D2s_v3"
#     imagePublisher             = "MicrosoftWindowsServer"
#     imageOffer                 = "WindowsServer"
#     imageSku                   = "2022-Datacenter-azure-edition"
#     imageVersion               = "latest"
#     createOption               = "FromImage"
#     diskSizeGB                 = 127
#     vmDiskStorageType          = "Standard_LRS"
#     subnetName                 = "snet-idnt-platform-dev-01"
#     vNetName                   = "vnet-idnt-platform-dev-01"
#     subnetresourceGroupName    = "rg-net-idnt-prd-phi-sea-001"
#     resourceGroupName          = "rg-idnt-test-01"
#     privateIPAllocationMethod  = "Dynamic"
#     vmNicSuffix                = "-nic-01"
#     ipConfigName               = "ipconfig2"
#     diskEncryptionKeyVaultName = ""
#     availabilityZone           = 3
#     encryptionAtHost           = true
#   }
# }

# backupVaults = {
#   "vault1" = {
#     backupvaultname         = "testbackupvault-002"
#     backupStorageRedundancy = "LocallyRedundant"
#     redundancy              = "LocallyRedundant"
#     datastore_type          = "VaultStore"

#   }
# }

# storagebackupPolicies = {
#   "policy1" = {
#     backup_policy_name               = "backuppolicy-idnt-platform-blob01"
#     backup_vault_Name                = "testbackupvault-002"
#     vault_default_retention_duration = "P30D"
#     identity_sub_id                  = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     location                         = "uaenorth"
#     backup_instance_name             = "blob-backup-instance-01"
#     resource_group_name              = "rg-backup-idnt-test-001"
#   }
# }

# diskBackupPolicies = {
#   "disk_policy1" = {
#     backup_policy_name               = "backuppolicy-disk01"
#     backup_vault_Name                = "testbackupvault-002"
#     subscriptionId                   = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
#     location                         = "uaenorth"
#     backup_instance_name             = "disk-backup-instance-01"
#     backupvault_resource_group_name  = "rg-backup-idnt-test-001"
#     managed_disk_resource_group_name = "rg-adds-idnt-prd-phi-sea-001"
#     snapshot_resource_group_name     = "rg-backup-idnt-test-001"
#     vmName                           = "idntvm-DC01"
#     osType                           = "Windows"

#   }
# }

# idntResourceLocks = {
#   #   "lock1" = {
#   #     name                = "Lock-netRG-idnt-sea-001"
#   #     lock_level          = "CanNotDelete"
#   #     notes               = "Lock to prevent accidental deletion"
#   #     resource_group_name = "rg-net-idnt-prd-phi-sea-001"
#   #   }
#   #   "lock2" = {
#   #     name                = "Lock-addsRG-idnt-sea-001"
#   #     lock_level          = "CanNotDelete"
#   #     notes               = "Lock to prevent accidental deletion"
#   #     resource_group_name = "rg-adds-idnt-prd-phi-sea-001"
#   #   },
#   "lock3" = {
#     name                = "Lock-commonRG-idnt-sea-001"
#     lock_level          = "CanNotDelete"
#     notes               = "Lock to prevent accidental deletion"
#     resource_group_name = "rg-common-idnt-prd-phi-sea-001"
#   }
#   # "lock4" = {
#   #   name                = "Lock-backupRG-idnt-sea-001"
#   #   lock_level          = "CanNotDelete"
#   #   notes               = "Lock to prevent accidental deletion"
#   #   resource_group_name = "rg-backup-idnt-prd-phi-sea-001"
#   # }
# }

#PaaS RG resources
# storage account
# storageAccounts = {
#   sa1 = {
#     name                      = "stssharedservicessea100"
#     resource_group_name       = "rg-paas-phi-sharedservices-sea-001"
#     location                  = "uaenorth"
#     account_tier              = "Standard"
#     account_replication_type  = "LRS"
#     shared_access_key_enabled = false
#   }

# }

#  LAW
idntWorkspace = {
  law1 = {
    name                     = "law-phi-idnt-ops-sea-001"
    resourceGroupName        = "rg-idnt-test-01"
    sku                      = "PerGB2018"
    retentionPeriod          = 30
    internetIngestionEnabled = false
    internetQueryEnabled     = false
    dailyQuotaGb             = 100
  }
}

# Mgmt nsg flow log
idntFlowLogs = {
  flowlog1 = {
    nsg_flow_log_name = "flow-log-phi-idnt-sea-001"
    nsgName           = "nsg-idnt-platform-dev-01"
    location          = "uaenorth"
    subscriptionId    = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
  }
}


identityDNSLink = {
  link1 = {
    name                  = "identity-dns-link-01"
    resource_group_name   = "rg-dns-conn-prd-phi-sea-001"
    private_dns_zone_name = "privatelink.blob.core.windows.net"
    registration_enabled  = false
  },
  link2 = {
    name                  = "identity-dns-link-02"
    resource_group_name   = "rg-dns-conn-prd-phi-sea-001"
    private_dns_zone_name = "privatelink.vaultcore.azure.net"
    registration_enabled  = false
  },
  link3 = {
    name                  = "identity-dns-link-01"
    resource_group_name   = "rg-dns-conn-prd-phi-sea-001"
    private_dns_zone_name = "privatelink.managedhsm.azure.net"
    registration_enabled  = false
  }
}


idntdatacollectionendpoint = {
  "endpoint1" = {
    datacollectionendpoint = "endpoint--phi-idnt-sea-001"
    resource_group_name    = "rg-idnt-test-01"
    location               = "uaenorth"
    kind                   = "Windows"
    #  public_network_access_enabled = false
  }
  "endpoint2" = {
    datacollectionendpoint = "endpoint--phi-idnt-sea-002"
    resource_group_name    = "rg-idnt-test-01"
    location               = "uaenorth"
    kind                   = "Linux"
    #  public_network_access_enabled = false
  }
}

dcr_configs = {
  dcr1 = {
    dcr_name                 = "dcr-windows-ssrc-sea-001"
    dcr_rg_name              = "rg-idnt-test-01"
    dcr_rg_location          = "uaenorth"
    dce_name                 = "endpoint--phi-idnt-sea-001"
    dce_rg_name              = "rg-idnt-test-01"
    destination_logworkspace = "law-phi-idnt-ops-sea-001"
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
    dcr_name                 = "dcr-linux-ssrc-sea-001"
    dcr_rg_name              = "rg-idnt-test-01"
    dcr_rg_location          = "uaenorth"
    dce_name                 = "endpoint--phi-idnt-sea-002"
    dce_rg_name              = "rg-idnt-test-01"
    destination_logworkspace = "law-phi-idnt-ops-sea-001"
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


