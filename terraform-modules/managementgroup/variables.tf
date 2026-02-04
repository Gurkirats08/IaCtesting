variable "platformManagementGroups" {
  type = map(object({
    name            = string
    displayName     = string
    parentId        = optional(string)
    subscriptionIds = optional(list(string))
  }))
}

variable "telemetryLocation" {
  type    = string
  default = null
}
