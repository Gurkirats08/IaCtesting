# Global Variables
variable "environment" {
  type        = string
  description = "Environment type"
}

variable "userAssignedIdentityName" {
  type = map(object({
    uai_name            = string
    location            = string
    resource_group_name = string
  }))
  description = "User Assigned Identity Name"
}

variable "mainLocation" {
  type        = string
  description = "Storage Account Name for nsg flow logs"
}

# Mgmt Resource Group
variable "resourceGroups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

# Virtual Network
variable "mgmtVirtualNetworks" {
  description = "Virtual networks"
  type = map(object({
    resourceGroupName  = string
    subscriptionId     = string
    VirtualNetworkName = string
    address_space      = string
    sku_name           = string
  }))
  default = {}
}
variable "mgmtRouteTables" {
  type = map(object({
    resourceGroupName             = string
    routeTableName                = string
    bgp_route_propagation_enabled = bool
    routes = list(object({
      name             = string
      addressPrefix    = string
      nextHopType      = string
      NextHopIpAddress = optional(string)
    }))
  }))
  description = "The route tables with their properties."
  default     = {}
}
variable "mgmtNetworkSecurityGroups" {
  type = map(object({
    name              = string
    tags              = optional(map(string))
    resourceGroupName = string
    securityRules = list(object({
      name        = string
      description = optional(string)
      properties = object({
        protocol                                 = string
        direction                                = string
        access                                   = string
        priority                                 = number
        sourceAddressPrefix                      = optional(string)
        sourceAddressPrefixes                    = optional(list(string))
        destinationAddressPrefix                 = optional(string)
        destinationAddressPrefixes               = optional(list(string))
        sourcePortRange                          = optional(string)
        sourcePortRanges                         = optional(list(string))
        destinationPortRange                     = optional(string)
        destinationPortRanges                    = optional(list(string))
        sourceApplicationSecurityGroupNames      = optional(list(string))
        destinationApplicationSecurityGroupNames = optional(list(string))
      })
    }))
  }))
  description = "The network security groups with their properties."
  default     = {}
}

variable "mgmtLogAnalyticsWorkspaces" {
  description = "Log Analytics workspaces"
  type = map(object({
    name                     = string
    resourceGroupName        = string
    sku                      = string
    retentionPeriod          = optional(number)
    internetIngestionEnabled = optional(bool)
    internetQueryEnabled     = optional(bool)
    dailyQuotaGb             = optional(number)
  }))
  default = {}
}

variable "mgmtStorageAccounts" {
  description = "Storage accounts"
  type = map(object({
    name                      = string
    account_tier              = string
    account_replication_type  = string
    resource_group_name       = string
    location                  = string
    shared_access_key_enabled = optional(bool)
  }))
  default = {}
}

variable "mgmtSubnets" {
  description = "The subnets with their properties."
  type = map(object({
    resourceGroupName = string
    vnet_key          = string
    name              = string
    addressPrefix     = string
    vnet_name         = string
    subscriptionId    = optional(string)
    nsgName           = optional(string)
    rtName            = optional(string)
  }))
  default = {}
}
variable "private_endpoint_network_policies" {
  type = string
}

variable "mgmtLogAnalyticsWorkspaces" {
  description = "Log Analytics workspace for management"
  type = object({
    name                     = string
    resourceGroupName        = string
    location                 = string
    sku                      = string
    retentionPeriod          = optional(number)
    internetIngestionEnabled = optional(bool)
    internetQueryEnabled     = optional(bool)
    dailyQuotaGb             = optional(number)
  })
  
}

