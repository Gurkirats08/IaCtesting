<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.25 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.this](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_mssql_server_extended_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_microsoft_support_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_microsoft_support_auditing_policy) | resource |
| [azurerm_role_assignment.sql_to_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sql_to_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_mssql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mssql_server) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blob_endpoint"></a> [blob\_endpoint](#input\_blob\_endpoint) | Storage Account blob endpoint for storing audit logs | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the existing Key vault to store the Customer Managed Key for Encryption. | `string` | n/a | yes |
| <a name="input_key_vault_key_id"></a> [key\_vault\_key\_id](#input\_key\_vault\_key\_id) | Key ID of the Customer Managed Key to be used for Encryption. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_login_username"></a> [login\_username](#input\_login\_username) | (Required) The login username of the Azure AD Administrator of this SQL Server. | `string` | n/a | yes |
| <a name="input_mssql_server_name"></a> [mssql\_server\_name](#input\_mssql\_server\_name) | The name of MSSQL Server | `string` | n/a | yes |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of Resources Group | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Storage Account Resource ID for storing audit logs | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags of the MS SQL Server. | `map(string)` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | User Assigned Identity Resource ID to assign to SQL Server | `string` | n/a | yes |
| <a name="input_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#input\_user\_assigned\_identity\_principal\_id) | User Assigned Identity Principal ID to assign to SQL Server | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fully_qualified_domain_name"></a> [fully\_qualified\_domain\_name](#output\_fully\_qualified\_domain\_name) | The fully qualified domain name of the Azure SQL Server. |
| <a name="output_id"></a> [id](#output\_id) | The Microsoft SQL Server ID. |
| <a name="output_name"></a> [name](#output\_name) | The Microsoft SQL Server Name. |
<!-- END_TF_DOCS -->