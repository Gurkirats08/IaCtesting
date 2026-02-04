variable "data_factory_name" {
  type        = string
  description = "The name of the Azure Data Factory."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Firewall."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = " Is Managed Virtual Network enabled?"
  default     = false
}


variable "customer_managed_key_id" {
  type        = string
  description = "Specifies the Azure Key Vault Key ID to be used as the Customer Managed Key (CMK) for double encryption. Required with user assigned identity."
  default     = null
}

variable "customer_managed_key_identity_id" {
  type        = string
  description = "Specifies the ID of the user assigned identity associated with the Customer Managed Key. Must be supplied if customer_managed_key_id is set."
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault to enable CMK."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Firewall."
  default     = null
}

variable "identity_type" {
  type        = string
  description = "Specifies the type of Managed Service Identity that should be configured. Possible values are SystemAssigned, UserAssigned or 'SystemAssigned, UserAssigned' (to enable both)."
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Identity type must be SystemAssigned, UserAssigned or 'SystemAssigned, UserAssigned'."
  }
}

variable "user_managed_identity_name" {
  type        = string
  description = "Optional. The Name of User managed Identity to be created as part of the module."
  default     = null
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned."
  default     = []
}

variable "github_configuration" {
  description = "Github configuration for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#github_configuration"
  type        = map(string)
  default     = null
}

variable "global_parameters" {
  description = "Global parameters for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#global_parameter"
  type        = list(map(string))
  default     = []
}

variable "azure_devops_configuration" {
  description = "Azure DevOps configuration for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#vsts_configuration"
  type        = map(string)
  default     = null
}

variable "integration_runtime_azure" {
  description = <<EOF
  List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.
    integration_runtime_custom_name = Integration runtime custom name
    integration_runtime_description = Integration runtime description
    integration_runtime_configuration = object({
      cleanup_enabled = (Optional) Cluster will not be recycled and it will be used in next data flow activity run until TTL (time to live) is reached if this is set as false. Default is true.
      compute_type = (Optional) Compute type of the cluster which will execute data flow job. Valid values are General, ComputeOptimized and MemoryOptimized. Defaults to General.
      core_count = (Optional) Core count of the cluster which will execute data flow job. Valid values are 8, 16, 32, 48, 80, 144 and 272. Defaults to 8.
      time_to_live_min = (Optional) Time to live (in minutes) setting of the cluster which will execute data flow job. Defaults to 0.
      virtual_network_enabled =  (Optional) Is Integration Runtime compute provisioned within Managed Virtual Network? Changing this forces a new resource to be created. Default is false.
    }))
  EOF
  type = map(object({
    integration_runtime_custom_name = optional(string)
    integration_runtime_description = optional(string)
    integration_runtime_configuration = optional(object({
      cleanup_enabled         = optional(bool)
      compute_type            = optional(string)
      core_count              = optional(number)
      time_to_live_min        = optional(number)
      virtual_network_enabled = optional(bool)
    }))
  }))
  default = {}
}

variable "integration_runtime_shir" {
  description = <<EOF
  List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.
    integration_runtime_custom_name = Integration runtime custom name
    integration_runtime_description = Integration runtime description
    rbac_authorization = object({
      id = (Optional) The ID of the Data Factory.
      primary_authorization_key = (Optional) The primary integration runtime authentication key.
      secondary_authorization_key = (Optional) The secondary integration runtime authentication key.
    }))
  EOF
  type = map(object({
    integration_runtime_custom_name = optional(string)
    integration_runtime_description = optional(string)
    run_cse                         = optional(bool)
    virtual_machine_id              = optional(string)
    # rbac_authorization = optional(object({
    #   id = optional(string)
    # }))
  }))
  default = {}
}

variable "integration_runtime_ssis" {
  description = <<EOF
  List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.
    integration_runtime_custom_name = Integration runtime custom name
    integration_runtime_description = Integration runtime description
    integration_runtime_configuration = object({
      cleanup_enabled = (Optional) Cluster will not be recycled and it will be used in next data flow activity run until TTL (time to live) is reached if this is set as false. Default is true.
      compute_type = (Optional) Compute type of the cluster which will execute data flow job. Valid values are General, ComputeOptimized and MemoryOptimized. Defaults to General.
      core_count = (Optional) Core count of the cluster which will execute data flow job. Valid values are 8, 16, 32, 48, 80, 144 and 272. Defaults to 8.
      time_to_live_min = (Optional) Time to live (in minutes) setting of the cluster which will execute data flow job. Defaults to 0.
      virtual_network_enabled =  (Optional) Is Integration Runtime compute provisioned within Managed Virtual Network? Changing this forces a new resource to be created. Default is false.
    }))
  EOF
  type = map(object({
    integration_runtime_custom_name = optional(string)
    integration_runtime_description = optional(string)
    integration_runtime_configuration = optional(object({
      node_size                        = optional(string)
      number_of_nodes                  = optional(number)
      max_parallel_executions_per_node = optional(number)
      edition                          = optional(string)
      license_type                     = optional(string)
      catalog_info = optional(object({
        server_endpoint        = optional(string)
        administrator_login    = optional(string)
        administrator_password = optional(string)
        pricing_tier           = optional(string)
        elastic_pool_name      = optional(string)
        dual_standby_pair_name = optional(string)
      }))
      custom_setup_script = optional(object({
        blob_container_uri = optional(string)
        sas_token          = optional(string)
      }))
      # express_custom_setup = optional(object({
      #   command_key = optional(map(any))
      #   component  = optional(map(any))
      #   environment = optional(string)
      #   powershell_version = optional(string)
      # }))
      express_vnet_integration = optional(object({
        subnet_id = optional(string)
      }))
      package_store = optional(object({
        name                = optional(string)
        linked_service_name = optional(string)
      }))
      proxy = optional(object({
        self_hosted_integration_runtime_name = optional(string)
        staging_storage_linked_service_name  = optional(string)
        path                                 = optional(string)
      }))
      vnet_integration = optional(object({
        vnet_id     = optional(string)
        subnet_id   = optional(string)
        subnet_name = optional(string)
        public_ips  = optional(string)
      }))
    }))
  }))
  default = {}
}
