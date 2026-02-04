## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.25 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_integration_runtime_azure.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure) | resource |
| [azurerm_data_factory_integration_runtime_azure_ssis.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure_ssis) | resource |
| [azurerm_data_factory_integration_runtime_self_hosted.integration_runtime](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.adf_user_managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_extension.shir_cse](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [random_password.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_offset.two_years](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |
| [time_static.current_time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_role_definition.kv_crypto_service_encryption_user_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_devops_configuration"></a> [azure\_devops\_configuration](#input\_azure\_devops\_configuration) | Azure DevOps configuration for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#vsts_configuration | `map(string)` | `null` | no |
| <a name="input_customer_managed_key_id"></a> [customer\_managed\_key\_id](#input\_customer\_managed\_key\_id) | Specifies the Azure Key Vault Key ID to be used as the Customer Managed Key (CMK) for double encryption. Required with user assigned identity. | `string` | `null` | no |
| <a name="input_customer_managed_key_identity_id"></a> [customer\_managed\_key\_identity\_id](#input\_customer\_managed\_key\_identity\_id) | Specifies the ID of the user assigned identity associated with the Customer Managed Key. Must be supplied if customer\_managed\_key\_id is set. | `string` | `null` | no |
| <a name="input_data_factory_name"></a> [data\_factory\_name](#input\_data\_factory\_name) | The name of the Azure Data Factory. | `string` | n/a | yes |
| <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration) | Github configuration for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#github_configuration | `map(string)` | `null` | no |
| <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters) | Global parameters for data factory. See documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory#global_parameter | `list(map(string))` | `[]` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be configured. Possible values are SystemAssigned, UserAssigned or 'SystemAssigned, UserAssigned' (to enable both). | `string` | `"SystemAssigned"` | no |
| <a name="input_integration_runtime_azure"></a> [integration\_runtime\_azure](#input\_integration\_runtime\_azure) | List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.<br>    integration\_runtime\_custom\_name = Integration runtime custom name<br>    integration\_runtime\_description = Integration runtime description<br>    integration\_runtime\_configuration = object({<br>      cleanup\_enabled = (Optional) Cluster will not be recycled and it will be used in next data flow activity run until TTL (time to live) is reached if this is set as false. Default is true.<br>      compute\_type = (Optional) Compute type of the cluster which will execute data flow job. Valid values are General, ComputeOptimized and MemoryOptimized. Defaults to General.<br>      core\_count = (Optional) Core count of the cluster which will execute data flow job. Valid values are 8, 16, 32, 48, 80, 144 and 272. Defaults to 8.<br>      time\_to\_live\_min = (Optional) Time to live (in minutes) setting of the cluster which will execute data flow job. Defaults to 0.<br>      virtual\_network\_enabled =  (Optional) Is Integration Runtime compute provisioned within Managed Virtual Network? Changing this forces a new resource to be created. Default is false.<br>    })) | <pre>map(object({<br>    integration_runtime_custom_name = optional(string)<br>    integration_runtime_description = optional(string)<br>    integration_runtime_configuration = optional(object({<br>      cleanup_enabled         = optional(bool)<br>      compute_type            = optional(string)<br>      core_count              = optional(number)<br>      time_to_live_min        = optional(number)<br>      virtual_network_enabled = optional(bool)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_integration_runtime_shir"></a> [integration\_runtime\_shir](#input\_integration\_runtime\_shir) | List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.<br>    integration\_runtime\_custom\_name = Integration runtime custom name<br>    integration\_runtime\_description = Integration runtime description<br>    rbac\_authorization = object({<br>      id = (Optional) The ID of the Data Factory.<br>      primary\_authorization\_key = (Optional) The primary integration runtime authentication key.<br>      secondary\_authorization\_key = (Optional) The secondary integration runtime authentication key.<br>    })) | <pre>map(object({<br>    integration_runtime_custom_name = optional(string)<br>    integration_runtime_description = optional(string)<br>    run_cse                         = optional(bool)<br>    virtual_machine_id              = optional(string)<br>    # rbac_authorization = optional(object({<br>    #   id = optional(string)<br>    # }))<br>  }))</pre> | `{}` | no |
| <a name="input_integration_runtime_ssis"></a> [integration\_runtime\_ssis](#input\_integration\_runtime\_ssis) | List of objects containing Configurations for the deployment of Integration Runtime of type 'Azure'.<br>    integration\_runtime\_custom\_name = Integration runtime custom name<br>    integration\_runtime\_description = Integration runtime description<br>    integration\_runtime\_configuration = object({<br>      cleanup\_enabled = (Optional) Cluster will not be recycled and it will be used in next data flow activity run until TTL (time to live) is reached if this is set as false. Default is true.<br>      compute\_type = (Optional) Compute type of the cluster which will execute data flow job. Valid values are General, ComputeOptimized and MemoryOptimized. Defaults to General.<br>      core\_count = (Optional) Core count of the cluster which will execute data flow job. Valid values are 8, 16, 32, 48, 80, 144 and 272. Defaults to 8.<br>      time\_to\_live\_min = (Optional) Time to live (in minutes) setting of the cluster which will execute data flow job. Defaults to 0.<br>      virtual\_network\_enabled =  (Optional) Is Integration Runtime compute provisioned within Managed Virtual Network? Changing this forces a new resource to be created. Default is false.<br>    })) | <pre>map(object({<br>    integration_runtime_custom_name = optional(string)<br>    integration_runtime_description = optional(string)<br>    integration_runtime_configuration = optional(object({<br>      node_size                        = optional(string)<br>      number_of_nodes                  = optional(number)<br>      max_parallel_executions_per_node = optional(number)<br>      edition                          = optional(string)<br>      license_type                     = optional(string)<br>      catalog_info = optional(object({<br>        server_endpoint        = optional(string)<br>        administrator_login    = optional(string)<br>        administrator_password = optional(string)<br>        pricing_tier           = optional(string)<br>        elastic_pool_name      = optional(string)<br>        dual_standby_pair_name = optional(string)<br>      }))<br>      custom_setup_script = optional(object({<br>        blob_container_uri = optional(string)<br>        sas_token          = optional(string)<br>      }))<br>      # express_custom_setup = optional(object({<br>      #   command_key = optional(map(any))<br>      #   component  = optional(map(any))<br>      #   environment = optional(string)<br>      #   powershell_version = optional(string)<br>      # }))<br>      express_vnet_integration = optional(object({<br>        subnet_id = optional(string)<br>      }))<br>      package_store = optional(object({<br>        name                = optional(string)<br>        linked_service_name = optional(string)<br>      }))<br>      proxy = optional(object({<br>        self_hosted_integration_runtime_name = optional(string)<br>        staging_storage_linked_service_name  = optional(string)<br>        path                                 = optional(string)<br>      }))<br>      vnet_integration = optional(object({<br>        vnet_id     = optional(string)<br>        subnet_id   = optional(string)<br>        subnet_name = optional(string)<br>        public_ips  = optional(string)<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the Key Vault to enable CMK. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Is Managed Virtual Network enabled? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Firewall. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the Firewall. | `map(string)` | `null` | no |
| <a name="input_user_managed_identity_name"></a> [user\_managed\_identity\_name](#input\_user\_managed\_identity\_name) | Optional. The Name of User managed Identity to be created as part of the module. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id) | Data factory id |
| <a name="output_data_factory_integration_runtime_id"></a> [data\_factory\_integration\_runtime\_id](#output\_data\_factory\_integration\_runtime\_id) | Data factory integration runtime id |
| <a name="output_data_factory_managed_identity"></a> [data\_factory\_managed\_identity](#output\_data\_factory\_managed\_identity) | System-managed identity |
| <a name="output_data_factory_managed_user_assigned_identity_id"></a> [data\_factory\_managed\_user\_assigned\_identity\_id](#output\_data\_factory\_managed\_user\_assigned\_identity\_id) | User-assigned identity |
| <a name="output_data_factory_managed_user_assigned_identity_name"></a> [data\_factory\_managed\_user\_assigned\_identity\_name](#output\_data\_factory\_managed\_user\_assigned\_identity\_name) | User-assigned identity |
| <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name) | Data factory name |
| <a name="output_data_factory_self_hosted_integration_runtime_primary_authorization_key"></a> [data\_factory\_self\_hosted\_integration\_runtime\_primary\_authorization\_key](#output\_data\_factory\_self\_hosted\_integration\_runtime\_primary\_authorization\_key) | The self hosted integration runtime primary authentication key |
| <a name="output_data_factory_self_hosted_integration_runtime_secondary_authorization_key"></a> [data\_factory\_self\_hosted\_integration\_runtime\_secondary\_authorization\_key](#output\_data\_factory\_self\_hosted\_integration\_runtime\_secondary\_authorization\_key) | The self hosted integration runtime secondary authentication key |
