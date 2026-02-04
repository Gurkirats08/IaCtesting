variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Windows Virtual Machine should exist"
  default     = null
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {
    monitor_enable = true
  }
}

# variable "networking_resource_group" {
#   type = string
# }

variable "virtual_network_name" {
  type    = string
  default = null
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "identity_ids" {
  type    = string
  default = null
}


variable "disk_encryption_set_id" {
  type    = string
  default = null
}

# -
# - Windows VM's
# -
variable "windows_vms" {
  type = map(object({
    vmName                          = optional(string)
    identityVMName                  = optional(string)
    computerName                    = optional(string)
    identityVMComputerName          = optional(string)
    zone                            = optional(map(string))
    vmSize                          = string
    availabilityZone                = optional(string)
    identityVmAvailabilityZone      = optional(string)
    location                        = optional(string)
    assignIdentity                  = optional(bool)
    availabilitySetKey              = optional(string)
    vmNicKeys                       = optional(list(string))
    imagePublisher                  = string
    imageOffer                      = string
    imageSku                        = string
    imageVersion                    = string
    osType                          = string
    #disk_encryption_set_id          = optional(string)
    storageOsDiskCaching            = optional(string)
    vmDiskStorageType               = optional(string)
    diskSizeGB                      = optional(number)
    writeAcceleratorEnabled         = optional(bool)
    recoveryServicesVaultName       = optional(string)
    vmBackupPolicyName              = optional(string)
    useExistingDiskEncryptionSet    = optional(bool)
    existingDiskEncryptionSetName   = optional(string)
    existingDiskEncryptionSetRgName = optional(string)
    vNetName                        = optional(string)
    enableCmkDiskEncryption         = optional(bool)
    customerManagedKeyName          = optional(string)
    diskEncryptionSetName           = optional(string)
    enableAutomaticUpdates          = optional(bool)
    customDataPath                  = optional(string)
    customDataArgs                  = optional(map(string))
    #location                             = string
    resourceGroupName         = string
    vmNicSuffix               = optional(string)
    identityVMNicSuffix       = optional(string)
    dnsServers                = optional(list(string))
    ipConfigName              = optional(string)
    privateIPAllocationMethod = optional(string)
    privateIPAddress          = optional(string)
    identityVMPrivateIp       = optional(string)
    extensionName             = optional(string)
    subnetName                = string
    subnetresourceGroupName   = string
    jumpBoxPrivateIP          = optional(string)
    # #  nicConfigurations = list(object({
    # #     vmNicSuffix                   = string
    # #     nsgName = string
    # #     dnsServers                  = list(string)
    # #     ipConfigurations           = list(object({
    # #       name                     = string
    # #       privateIPAllocationMethod = string
    # #       privateIPAddress           = string
    # #       subnetName           = string
    # #     }))
    #   }))

  }))
  description = "Map containing Windows VM objects"
  default     = {}
}

variable "windows_vm_nics" {
  type = map(object({
    name                           = string
    subnet_name                    = string
    vnet_name                      = string
    networking_resource_group      = string
    lb_backend_pool_names          = list(string)
    lb_nat_rule_names              = list(string)
    app_security_group_names       = list(string)
    app_gateway_backend_pool_names = list(string)
    internal_dns_name_label        = string
    enable_ip_forwarding           = bool
    enable_accelerated_networking  = bool
    dns_servers                    = list(string)
    location                       = string
    resource_group_name            = string
    nic_ip_configurations = list(object({
      name      = string
      static_ip = string
    }))
  }))
  description = "Map containing Windows VM NIC objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
  default     = null
}

# -
# - Availability Sets
# -
variable "availability_sets" {
  type = map(object({
    name                         = string
    platform_update_domain_count = number
    platform_fault_domain_count  = number
    location                     = string
    resource_group_name          = string
  }))
  description = "Map containing availability set configurations"
  default     = {}
}

# -
# - Diagnostics Extensions
# -
variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
  default     = null
}

# variable "key_vault_name" {
#   type        = string
#   description = "key vault id"

# }


variable "kv_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in KV resource?"
  default     = false
}

variable "self_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in VM resource ?"
  default     = false
}

# -
# - Managed Disks
# -
variable "managed_data_disks" {
  type = map(object({
    disk_name                 = string
    vm_key                    = string
    location                  = string
    resource_group_name       = string
    lun                       = string
    storage_account_type      = string
    disk_size                 = number
    caching                   = string
    write_accelerator_enabled = bool
    create_option             = string
    os_type                   = string
    source_resource_id        = string
    #location            = string
    #resource_group_name = string
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
variable "source_image_reference_publisher" {
  type    = string
  default = null
}

variable "source_image_reference_offer" {
  type    = string
  default = null
}

variable "source_image_reference_sku" {
  type    = string
  default = null
}

variable "source_image_reference_version" {
  type    = string
  default = null
}

variable "location" {
  type        = string
  description = "location of keyvault"
  default     = "westeurope"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ResourceId of log analytic workspace where diagnosticsetting will be saved"
  default     = null
}
