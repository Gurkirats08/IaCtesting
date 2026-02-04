variable "resource_group_name" {
  type        = string
  description = "The resource group name."
}

variable "location" {
  type        = string
  description = "The region were the resource will be deployed."
}

variable "azurerm_eventhub_namespace_name" {
  type        = string
  description = "The eventhub namespace name."
}

variable "capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  default     = null
}

variable "zone_redundant" {
  type        = bool
  description = "Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). Changing this forces a new resource to be created."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}

variable "local_authentication_enabled" {
  type        = bool
  description = "Is SAS authentication enabled for the EventHub Namespace? Defaults to true."
  default     = false # 3AEH_IAM_005
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Is public network access enabled for the EventHub Namespace? Defaults to true"
  default     = false # AEH_NET_001
}

variable "network_rulesets" {
  type = object({
    default_action                 = string
    trusted_service_access_enabled = bool
    public_network_access_enabled  = bool
    virtual_network_rule = object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = bool
    })
    ip_rule = list(object({
      ip_mask = string
      action  = string
    }))
  })
  description = "An object for network rule sets:<ul><li>`default_action`: (Required) The default action to take when a rule is not matched. Possible values are `Allow` and `Deny`. `Defaults` to `Deny`.</li><li>`trusted_service_access_enabled`: (Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.</li><li>`virtual_network_rule`: (Optional) An object for the virtual network rule.</li><li>`ip_rule `: (Optional) An object for the virtual IP rule.</li></ul>"
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "ID of the existing Key vault to store the Customer Managed Key for Encryption."
}

variable "key_type" {
  type        = string
  description = "Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created."
  default     = "RSA"
}

variable "key_size" {
  type        = string
  description = "Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM. Changing this forces a new resource to be created."
  default     = "4096"
}

variable "role_definition_name" {
  type        = string
  description = " The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role_definition_id."
  default     = "Key Vault Crypto Service Encryption User"
}

variable "key_expiration_date" {
  type        = string
  description = "Expiration UTC datetime (YYYY-mm-dd'T'HH:MM:SS'Z') for key."
  default     = null
}
