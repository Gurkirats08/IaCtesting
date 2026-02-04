##Pre-requisites##
variable "dce_name" {
  description = "The name of the existing Data collection endpoint"
  type = string
}

variable "os_type" {
  description = "os type"
  type = string
}

variable "dce_rg_name" {
  description = "The name of the existing Data collection endpoint resource group"
  type = string
}

variable "law_name" {
  description = "The name of the existing log analytics workspace"
  type = string
}

variable "law_rg_name" {
  description = "The name of the existing log analytics workspace resource group"
  type = string
}
##Pre-requisites ENDS##

variable "dcr_name" {
  description = "The name of the Data collection rule"
  type = string
}

variable "dcr_rg_name" {
  description = "The name of the Data collection rule resource group"
  type = string
}

variable "dcr_rg_location" {
  description = "location of data collection rule"
  type = string
  default = "uaenorth"
}

variable "destination_logworkspace" {
  description = "The name of the destination log analytics workspace"
  type    = string
  
}

variable "data_flow_streams" {
  type    = list(string)
  default = null
}

variable "datasource_perfcounter" {
  type    = list(string)
  default = null
}

variable "datasource_perfCounterSpecifiers" {
  type    = list(string)
  default = null
}

variable "win_perfcounter_name" {
  type    = string
  default = null
}

variable "win_event_log_stream" {
  type    = list(string)
  default = null
}

variable "win_path_Query" {
  type    = list(string)
  default = null
}

variable "win_log_name" {
  type    = string
  default = null
}

variable "linux_event_log_stream" {
  type    = list(string)
  default = null
}

variable "linux_loglevels" {
  type    = list(string)
  default = null
}

variable "linux_log_name" {
  type    = string
  default = null
}


variable "tags" {
  description = "Tags as key value pairs"
  type        = map(string)
}