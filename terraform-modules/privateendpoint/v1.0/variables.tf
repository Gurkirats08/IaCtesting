variable "private_endpoint_name" {
  type        = string
  description = "Name of private endpoint."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name in wich private endpoint reside."
}

variable "location" {
  type        = string
  description = "location of private endpoint."
  default     = "centralindia"
}

variable "subnet_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
}

variable "private_dns_zone_id" {
  description = "Resource id of private DNS Zone."
  type        = string
}

variable "private_connection_resource_id" {
  description = "The resource ID of the service to connect privately."
}

variable "subresource_names" {
  description = "Specifies the list of Private DNS Zones to include within the private_dns_zone_group"
  type        = list(string)
}
