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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the route table. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | The route table with its properties. | <pre>object({<br>    disable_bgp_route_propagation = bool<br>    routes = list(object({<br>      name                   = string<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = string<br>    }))<br>  })</pre> | <pre>{<br>  "disable_bgp_route_propagation": false,<br>  "routes": []<br>}</pre> | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | The name of the route table. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of the Subnet. Changing this forces a new resource to be created. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Specifies the id of the Route table |
| <a name="output_name"></a> [name](#output\_name) | Specifies the name of the Route table |
<!-- END_TF_DOCS -->