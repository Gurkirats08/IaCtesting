variable "main_location" {
  type = string
}

variable "environment" {
  type = string
}

# -
# - DDoS Protection Plan
# -
variable "ddos_plans" {
  description = "The DDoS plans with their properties."
  type = map(object({
    name              = string
    resourceGroupName = string
    tags              = optional(map(string))
  }))
  default = {}
}
