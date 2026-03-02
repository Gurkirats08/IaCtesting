variable "action_group_name" {
  description = "Name of the action group"
  type        = string
  
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "short_name" {
  description = "Short name of the action group"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}

variable "alert_name" {
  description = "Name of the alert"
  type        = string
}

variable "scopes" {
  description = "Scope of the alert"
  type        = list(string)
}

variable "description" {
  description = "Description of the alert"
  type        = string
}

variable "enabled" {
  description = "Is the alert enabled?"
  type        = bool
}

variable "metric_namespace" {
  description = "Namespace of the metric"
  type        = string
}

variable "metric_name" {
  description = "Name of the metric"
  type        = string
}

variable "aggregation" {
  description = "Aggregation type"
  type        = string
}

variable "operator" {
  description = "Operator"
  type        = string
}

variable "threshold" {
  description = "Threshold"
  type        = number
}

