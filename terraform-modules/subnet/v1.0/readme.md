<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =3.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | The address prefixes for the subnet. | `string` | n/a | yes |
| <a name="input_azurerm_subnet_name"></a> [azurerm\_subnet\_name](#input\_azurerm\_subnet\_name) | The subnet name. | `any` | n/a | yes |
| <a name="input_azurerm_virtual_network_name"></a> [azurerm\_virtual\_network\_name](#input\_azurerm\_virtual\_network\_name) | VNet name. | `any` | n/a | yes |
| <a name="input_delegation_name"></a> [delegation\_name](#input\_delegation\_name) | A name for this delegation. | `any` | `null` | no |
| <a name="input_enforce_private_link_endpoint_network_policies"></a> [enforce\_private\_link\_endpoint\_network\_policies](#input\_enforce\_private\_link\_endpoint\_network\_policies) | n/a | `bool` | `false` | no |
| <a name="input_enforce_private_link_service_network_policies"></a> [enforce\_private\_link\_service\_network\_policies](#input\_enforce\_private\_link\_service\_network\_policies) | n/a | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The region were the resource will be deployed. | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `any` | n/a | yes |
| <a name="input_service_delegation_actions"></a> [service\_delegation\_actions](#input\_service\_delegation\_actions) | A list of Actions which should be delegated. This list is specific to the service to delegate to. | `any` | `null` | no |
| <a name="input_service_delegation_type"></a> [service\_delegation\_type](#input\_service\_delegation\_type) | A service\_delegation block as defined below. | `any` | `null` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the resource created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resoruce created. |
<!-- END_TF_DOCS -->
