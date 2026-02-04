variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the route table. Changing this forces a new resource to be created."
}

variable "route_table_name" {
  type        = string
  description = "The name of the route table. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to the resource."
}

variable "route_table" {
  type = object({
 //   disable_bgp_route_propagation = bool
    bgp_route_propagation_enabled = bool
    routes = list(object({
      name             = string
      addressPrefix    = string
      nextHopType      = string
      NextHopIpAddress = optional(string)
    }))
  })
  description = "The route table with its properties."
  default = {
 //   disable_bgp_route_propagation = false
    bgp_route_propagation_enabled = true
    routes                        = []
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "The ID of the Subnet. Changing this forces a new resource to be created."
  default     = []
}
