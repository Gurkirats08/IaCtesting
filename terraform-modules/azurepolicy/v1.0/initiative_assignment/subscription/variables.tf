variable "policy_assignments" {
  description = "List of policy assignments"
  type = map(object({
    name                  = string
    display_name          = string
    description           = string
    assignment_parameters = optional(any, {})
    assignment_effect     = string
    enforce               = bool
    policy_definition_id  = string
    location              = string
    subscription_id       = optional(string)
    management_group_id   = optional(string)
  }))
}
