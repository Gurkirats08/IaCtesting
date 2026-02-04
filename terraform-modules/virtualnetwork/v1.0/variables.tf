variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network. Changing this forces a new resource to be created.."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "dns_servers" {
  # We will accept a single server as string or a list of strings
  type        = string
  description = "List of IP addresses of DNS servers"
  default     = "168.63.129.16"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network."
}

variable "ddos_protection_plan_ddos_id" {
  type        = string
  description = "The id of the DDoS that will be used"
  default     = null
}

variable "tags" {
  type    = map(string)
  default = null
}

