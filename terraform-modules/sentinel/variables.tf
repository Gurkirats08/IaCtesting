variable "is_cmk_enabled" {
  type        = bool
  description = "Is Customer managed key enabled"
  default = false
}

variable "workspace_id" {
  type        = string
  description = "workspace resourceid to be onboarded on sentinel"
}
