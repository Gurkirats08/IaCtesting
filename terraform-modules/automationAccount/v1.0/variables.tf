variable "main_location" {
  type        = string
  description = "Location for deployment"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

# -
# - Automation Accounts
# -
variable "automation_accounts" {
  description = "The automation accounts with their properties."
  type = map(object({
    name                       = string
    resourceGroupName          = string
    type                       = string
    sku                        = string
    localAuthenticationEnabled = optional(bool)
    publicNetworkAccessEnabled = optional(string)
    identityType               = string
    identityIds                = optional(list(string))
    tags                       = optional(map(string))
  }))
  default = {}
}
