<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.25 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_customer_managed_key) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azurerm_eventhub_namespace_name"></a> [azurerm\_eventhub\_namespace\_name](#input\_azurerm\_eventhub\_namespace\_name) | The eventhub namespace name. | `string` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20. | `number` | `null` | no |
| <a name="input_key_expiration_date"></a> [key\_expiration\_date](#input\_key\_expiration\_date) | Expiration UTC datetime (YYYY-mm-dd'T'HH:MM:SS'Z') for key. | `string` | `null` | no |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key\_type is RSA or RSA-HSM. Changing this forces a new resource to be created. | `string` | `"4096"` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created. | `string` | `"RSA"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the existing Key vault to store the Customer Managed Key for Encryption. | `string` | n/a | yes |
| <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled) | Is SAS authentication enabled for the EventHub Namespace? Defaults to true. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The region were the resource will be deployed. | `string` | n/a | yes |
| <a name="input_network_rulesets"></a> [network\_rulesets](#input\_network\_rulesets) | An object for network rule sets:<ul><li>`default_action`: (Required) The default action to take when a rule is not matched. Possible values are `Allow` and `Deny`. `Defaults` to `Deny`.</li><li>`trusted_service_access_enabled`: (Optional) Whether Trusted Microsoft Services are allowed to bypass firewall.</li><li>`virtual_network_rule`: (Optional) An object for the virtual network rule.</li><li>`ip_rule `: (Optional) An object for the virtual IP rule.</li></ul> | <pre>object({<br>    default_action                 = string<br>    trusted_service_access_enabled = bool<br>    public_network_access_enabled  = bool<br>    virtual_network_rule = object({<br>      subnet_id                                       = string<br>      ignore_missing_virtual_network_service_endpoint = bool<br>    })<br>    ip_rule = list(object({<br>      ip_mask = string<br>      action  = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Is public network access enabled for the EventHub Namespace? Defaults to true | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role\_definition\_id. | `string` | `"Key Vault Crypto Service Encryption User"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). Changing this forces a new resource to be created. | `bool` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_primary_connection_string"></a> [default\_primary\_connection\_string](#output\_default\_primary\_connection\_string) | The primary connection string for Event Hub namespace |
| <a name="output_id"></a> [id](#output\_id) | The EventHub Namespace ID. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | The Client ID of the Service Principal assigned to this EventHub Namespace |
| <a name="output_name"></a> [name](#output\_name) | The name of the event hub namesapce created. |
<!-- END_TF_DOCS -->