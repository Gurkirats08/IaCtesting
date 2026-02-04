variable "name" {
  type        = string
  description = "Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created."
}

variable "target_resource_id" {
  type        = string
  description = "The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created."
}

variable "eventhub_name" {
  type        = string
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent. Changing this forces a new resource to be created."
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the Storage Account where logs should be sent. Changing this forces a new resource to be created."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. Changing this forces a new resource to be created."
  default     = null
}

variable "logs_categories" {
  type        = list(string)
  description = "The name of a Diagnostic Log Category for this Resource."
  default     = null
}

variable "metrics" {
  description = "Metrics to add."
  type        = list(string)
  default     = null
}
