<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.this](https://registry.terraform.io/providers/Azure/azapi/1.5.0/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azurerm_key_vault_name"></a> [azurerm\_key\_vault\_name](#input\_azurerm\_key\_vault\_name) | Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name. | `string` | n/a | yes |
| <a name="input_enabledForDeployment"></a> [enabledForDeployment](#input\_enabledForDeployment) | Property to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `true` | no |
| <a name="input_enabledForDiskEncryption"></a> [enabledForDiskEncryption](#input\_enabledForDiskEncryption) | Property to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `true` | no |
| <a name="input_enabledForTemplateDeployment"></a> [enabledForTemplateDeployment](#input\_enabledForTemplateDeployment) | Property to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group in which to create the Key Vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | `"standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the key vault created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the key vault created. |
<!-- END_TF_DOCS -->
