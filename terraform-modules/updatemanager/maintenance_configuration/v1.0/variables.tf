variable "maintenance_configuration_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "scope" {
  type = string
}

variable "visibility" {
  type = string
}

variable "in_guest_user_patch_mode" {
  type = string
}

variable "maintenance_start_time" {
  type = string
}

variable "maintenance_expiration_time" {
  type = string
}

variable "maintenance_duration" {
  type = string
}

variable "timezone" {
  type = string
}

variable "recur_every" {
  type = string
}

variable "linux_classifications" {
  type = list(string)
}

variable "linux_excluded_packages" {
  type = list(string)
}

variable "linux_included_packages" {
  type = list(string)
}

variable "windows_classifications" {
  type = list(string)
}

variable "kb_numbers_to_exclude" {
  type = list(string)
}

variable "kb_numbers_to_include" {
  type = list(string)
}

variable "reboot" {
  type = string
}


