variable "log_analytics_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "workspaces" {
  type = map(object({
    name                     = string
    resourceGroupName        = string
    sku                      = string
    retentionPeriod          = optional(number)
    internetIngestionEnabled = optional(bool)
    internetQueryEnabled     = optional(bool)
    dailyQuotaGb             = optional(number)
  }))
}

variable "location" {
  type        = string
  description = "The region where the resource will be deployed."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the Resource Group."
  default     = {
    environment = "test"
  }
  
}