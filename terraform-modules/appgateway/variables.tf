variable "name" {
  type        = string
  description = "The name of the Application Gateway. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to the Application Gateway should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created."
}

variable "sku_capacity" {
  type        = string
  description = "The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set."
  default     = "2"
}

variable "sku_name" {
  type = string
  description = "sku name"
}

variable "sku_tier" {
  type = string
  description = "sku tier"
}

variable "gateway_ip_configuration_name" {
  type = string
  description = "gateway ip configuration name"
}

variable "gateway_ip_configuration_subnet_id" {
  type        = string
  description = "The ID of the Subnet which the Application Gateway should be connected to."
}

variable "frontend_port_name" {
  type = string
  description = "frontend port name"
}

variable "frontend_port_number" {
  type = number
  description = "frontend port number"
}

variable "frontend_ip_configuration_name"{
  type = string
  description = "frontend ip configuration name"
}

variable "public_ip_name" {
  type        = string
  description = "The name of the public IP address to use for this Application Gateway. Changing this forces a new resource to be created."
  default     = null
  
}


variable "zones" {
  type        = list(string)
  description = "The availability zones for the Application Gateway."
  default     = ["1", "2", "3"]  
}

variable "frontend_ip_configuration_public_ip_address_id" {
  type = string
  description = "frontend ip configuration public ip address id"
  default = null
}

variable "backend_address_pool_name" {
  type = string
  description = "backend address pool name"
}

variable "backend_http_settings_name" {
  type = string
  description = "backend http settings name"
}

variable "backend_http_settings_cookie_based_affinity" {
  type = string
  description = "backend_http_settings_cookie_based_affinity"
}

variable "backend_http_settings_path" {
  type = string
  description = "backend_http_settings_path"
  default = null
}

variable "backend_http_settings_port" {
  type = number
  description = "backend_http_settings_port"
}

variable "backend_http_settings_protocol" {
  type = string
  description = "backend_http_settings_protocol"
}

variable "backend_http_settings_request_timeout" {
  type = number
  description = "backend_http_settings_request_timeout"
  default = 30
}

variable "http_listener_name" {
  type = string
  description = "http_listener_name"
}

variable "http_listener_protocol" {
  type = string
  description = "http_listener_protocol"
}

variable "request_routing_rule_name" {
  type = string
  description = "request_routing_rule_name"
}

variable "request_routing_rule_priority" {
  type = number
  description = "request_routing_rule_priority"
}

variable "request_routing_rule_type" {
  type = string
  description = "request_routing_rule_type"
}