variable "action_groups" {
  type = map(object({
    action_group_name           = string
    action_group_short_name     = string
    action_group_rg_name        = string
    action_group_enabled        = string
    tags                        = map(string)
    action_group_email_receiver = list(map(string))
  }))
  default = {}
}
variable "metric_alerts" {
  type = map(object({
    alert_name                      = string
    alert_rg_name                   = string
    alert_scopes                    = list(string)
    alert_description               = string
    tags                            = map(string)
    alert_enabled                   = bool
    severity                        = number
    alert_frequency                 = string
    alert_window_size               = string
    alert_target_resource_type      = string
    alert_target_resource_location  = string
    metric_namespace                = string
    metric_name                     = string
    aggregation                     = string
    operator                        = string
    threshold                       = string
    action_group_name               = string
  }))
  default = {}
}

variable "activity_log_alerts" {
  type = map(object({
    alert_name        = string
    alert_rg_name     = string
    location          = string
    alert_scopes      = list(string)
    description       = string
    tags              = map(string)
    operation_name    = string
    action_group_name = string
    category          = string
  }))

  default = {}
}
variable "service_health_alerts" {
  type = map(object({
    alert_name        = string
    alert_rg_name     = string
    location          = string
    alert_scopes      = list(string)
    description       = string
    tags              = map(string)
    operation_name    = string
    action_group_name = string
    category          = string
    service_health_events = list(string)
    service_health_locations = list(string)
    service_health_services = list(string)
  }))

  default = {}
}