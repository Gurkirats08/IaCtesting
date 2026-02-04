variable "resource_group_name" {
  description = "The name of Resources Group"
  type        = string
}

variable "location" {
  type        = string
  description = "The region were the resource will be deployed."
}

variable "network_watcher_name" {
  description = "The name of Network Watcher"
  type        = string
}
