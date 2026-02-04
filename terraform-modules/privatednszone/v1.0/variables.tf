variable "resource_group_name" {
  type        = string
  description = "the name of Resources Group"
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of Private DNS Zone"
}

variable "soa_email" {
  type        = string
  description = "The email address for the Start of Authority (SOA) record. Optional."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Private DNS Zone."
  default     = null
}
