locals {
  # convert assignment parameters to the required assignment structure
  parameter_values = { for key, val in var.policy_assignments : "${val.name}|${val.management_group_id}" => val.assignment_parameters != {} ? {
    for key, value in val.assignment_parameters :
    key => merge({ value = value })
  } : {} }

  # merge effect and parameter_values if specified, will use definition default effects if omitted
  parameters = { for key, val in local.parameter_values : key => val != null ? var.policy_assignments[key].assignment_effect != null ? jsonencode(merge(val, { effect = { value = var.policy_assignments[key].assignment_effect } })) : jsonencode(val) : null }
}
