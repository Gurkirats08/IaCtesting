## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.36.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.36.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_solution.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store LAW Workspace Id and Key. | `string` | `null` | no |
| <a name="input_log_analytics_additional_tags"></a> [log\_analytics\_additional\_tags](#input\_log\_analytics\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Log Analytics Workspace is created | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The workspace data retention in days. Possible values range between 30 and 730 | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_law_id"></a> [law\_id](#output\_law\_id) | n/a |
| <a name="output_law_id_map"></a> [law\_id\_map](#output\_law\_id\_map) | n/a |
| <a name="output_law_key"></a> [law\_key](#output\_law\_key) | n/a |
| <a name="output_law_name"></a> [law\_name](#output\_law\_name) | n/a |
| <a name="output_law_workspace"></a> [law\_workspace](#output\_law\_workspace) | n/a |
| <a name="output_law_workspace_id"></a> [law\_workspace\_id](#output\_law\_workspace\_id) | n/a |
