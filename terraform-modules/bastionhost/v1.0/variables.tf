variable "main_location" {
  type        = string
  description = "Location for resource deployment"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "bastion_host_additional_tags" {
  type        = map(string)
  description = "Bastion Host resources tags, in addition to the resource group tags."
  default     = {}
}

variable "resourceGroupName" {
  type        = string
  description = "The name of the resource group in which the Bastion Host will be created." 
}

# -
# - Public IP object
# -
variable "bastion_hosts" {
  type = map(object({
    bastionName        = string
    resourceGroupName  = string
    subscriptionId     = string
    VirtualNetworkName = string
    bastionIPName      = string
  }))
  description = "The Bostion Host with their properties."
  default     = {}
}

# variable "bastion_hosts" {
#   description = "The name of the Bastion host."
#   type        = string
# }
