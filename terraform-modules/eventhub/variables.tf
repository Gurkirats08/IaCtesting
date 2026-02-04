variable "eventhub_name" {
  type        = string
  description = "Specifies the name of the EventHub resource. Changing this forces a new resource to be created."
}

variable "eventhub_namespace_name" {
  type        = string
  description = "Specifies the name of the EventHub Namespace. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the EventHub's parent Namespace exists. Changing this forces a new resource to be created."
}

variable "partition_count" {
  type        = number
  description = "Specifies the current number of shards on the Event Hub.`partition_count` cannot be changed unless Eventhub Namespace SKU is `Premium`."
}

variable "message_retention" {
  type        = number
  description = "Specifies the number of days to retain the events for this Event Hub."
  default     = 90
}

variable "status" {
  type        = string
  description = "Specifies the status of the Event Hub resource. Possible values are Active, Disabled and SendDisabled. Defaults to Active."
  default     = "Active"
  validation {
    condition     = contains(["Active", "Disabled", "SendDisabled"], var.status)
    error_message = "Value of status must be one of : [Active, Disabled and SendDisabled]."
  }
}

variable "capture_description" {
  type = map(object({
    enabled             = bool
    encoding            = string
    interval_in_seconds = number
    size_limit_in_bytes = number
    skip_empty_archives = bool
    destination = object({
      name                = string
      archive_name_format = string
      blob_container_name = string
      storage_account_id  = string
    })
  }))
  description = "A map for capture feature for the eventhub:<ul><li>`enabled`: (Required) Specifies if the Capture Description is Enabled.</li><li>`encoding`: (Required) Specifies the Encoding used for the Capture Description. Possible values are `Avro` and `AvroDeflate`.</li><li>`interval_in_seconds`: (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between `60` and `900` seconds. Defaults to `300` seconds.</li><li>`size_limit_in_bytes`: (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between `10485760` and `524288000` bytes. Defaults to `314572800` bytes.</li><li>`skip_empty_archives`: (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to `false`.</li></ul>"
  default     = {}
}

variable "enable_authorization" {
  description = "Is authorization rule enabled?"
  type        = bool
  default     = false
}

variable "manage" {
  type        = string
  description = "Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is true - both listen and send must be too."
  default     = false
}

variable "listen" {
  type        = string
  description = "Does this Authorization Rule have permissions to Listen to the Event Hub?"
  default     = true
}

variable "send" {
  type        = string
  description = "Does this Authorization Rule have permissions to Send to the Event Hub"
  default     = true
}

variable "eventhub_consumer_group_name" {
  type        = string
  description = "Specifies the name of the EventHub Consumer Group resource."
}
