variable "application_insight_name" {
  type        = string
  description = "Specifies the name of the Application Insights component."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the network security group."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = null
}

variable "application_type" {
  type = string
  validation {
    condition = (
      var.application_type != null
      && contains(["ios", "java", "MobileCenter", "Node.JS", "other", "phone", "store", "web"], var.application_type)
    )
    error_message = "Invalid 'application_type'. It must not be null and be one of: ios, java, MobileCenter, Node.JS, other, phone, store, web"
  }
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Specifies the Application Insights component daily data volume cap in GB."
  default     = null
}

variable "daily_data_cap_notifications_disabled" {
  type        = bool
  description = "Specifies if a notification email will be send when the daily data volume cap is met."
  default     = false
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90."
  default     = 90
}

variable "sampling_percentage" {
  type        = number
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry."
  default     = 90
}

variable "disable_ip_masking" {
  type        = bool
  description = "By default the real client IP is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client IP. Defaults to false."
  default     = false
}

variable "workspace_id" {
  type        = string
  description = "Specifies the id of a log analytics workspace resource."
  default     = null
}

variable "local_authentication_disabled" {
  type        = bool
  description = "Disable Non-Azure AD based Auth. Defaults to false."
  default     = false
}

variable "internet_ingestion_enabled" {
  type        = bool
  description = "Should the Application Insights component support ingestion over the Public Internet? Defaults to true."
  default     = true
}

variable "internet_query_enabled" {
  type        = bool
  description = "Should the Application Insights component support querying over the Public Internet? Defaults to true."
  default     = true
}

variable "force_customer_storage_for_profiler" {
  type        = bool
  description = "Should the Application Insights component force users to create their own storage account for profiling? Defaults to false."
  default     = false
}
