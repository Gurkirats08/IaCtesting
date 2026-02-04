variable "platformSubscriptions" {
  type = map(object({
    displayName       = string
    aliasName         = string
    managementGroupId = optional(string)
    workloadType      = optional(string)
    tags              = optional(map(string))
  }))
  description = <<-EOT
  List of objects of subscription details. For more details, please refer to the following link: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription
  ```
  {
    subscription_display_name = (Required) The Name of the Subscription. This is the Display Name in the portal.
    subscription_alias_name   = (Required) The Alias name for the subscription. Terraform will generate a new GUID if this is not supplied. Changing this forces a new Subscription to be created.
    subscription_workload     = (Optional) The workload type of the Subscription. Possible values are Production (default) and DevTest. Changing this forces a new Subscription to be created.
    subscription_tags         = (Optional) A mapping of tags to assign to the Subscription.
  }
  ```
  EOT
}

variable "billingAccountName" {
  type        = string
  description = "The name of the billing account to use for the subscription alias."
}

variable "enrollmentAccountName" {
  type        = string
  description = "The name of the enrollment account to use for the subscription alias."
}
