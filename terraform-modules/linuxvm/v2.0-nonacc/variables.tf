variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Linux Virtual Machine should exist"
}

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

variable "linux_vms" {
  type = map(object({
    vmName         = optional(string)
    connVMName     = optional(string)
    vmSize         = string
    location       = optional(string)
    imagePublisher = string
    imageOffer     = string
    imageSku       = string
    imageVersion   = string
    osType         = string
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
    ConnlinuxNicSuffix        = optional(string)
    ConnlinuxVMPrivateIp      = optional(string)
    dnsServers                = optional(list(string))
    ipConfigName              = optional(string)
    privateIPAllocationMethod = optional(string)
    privateIPAddress          = optional(string)
    identityVMPrivateIp       = optional(string)
    extensionName             = optional(string)
    subnetName                = string
    jumpBoxPrivateIP          = optional(string)
    diskEncryptionKeyVaultName = optional(string)
    vmNicSuffix                = optional(string)
    subnetresourceGroupName   = optional(string)

  }))
  description = "Map containing Linux VM objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

variable "location" {
  type        = string
  description = "Specifies the Azure location where the Linux Virtual Machine should exist"

}

variable "primary" {
  type        = bool
  description = "Specifies if this is the primary IP configuration for the network interface"
  default     = true

}

variable "cse_settings_object" {
  type        = map(any)
  description = "Settings attribute used for Custom Script Extension"
  default     = { "commandToExecute" : "hostname && uptime" }
}
