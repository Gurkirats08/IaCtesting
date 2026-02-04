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
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule) | resource |
| [azurerm_eventhub_consumer_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capture_description"></a> [capture\_description](#input\_capture\_description) | A map for capture feature for the eventhub:<ul><li>`enabled`: (Required) Specifies if the Capture Description is Enabled.</li><li>`encoding`: (Required) Specifies the Encoding used for the Capture Description. Possible values are `Avro` and `AvroDeflate`.</li><li>`interval_in_seconds`: (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between `60` and `900` seconds. Defaults to `300` seconds.</li><li>`size_limit_in_bytes`: (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between `10485760` and `524288000` bytes. Defaults to `314572800` bytes.</li><li>`skip_empty_archives`: (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to `false`.</li></ul> | <pre>map(object({<br>    enabled             = bool<br>    encoding            = string<br>    interval_in_seconds = number<br>    size_limit_in_bytes = number<br>    skip_empty_archives = bool<br>    destination = object({<br>      name                = string<br>      archive_name_format = string<br>      blob_container_name = string<br>      storage_account_id  = string<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_enable_authorization"></a> [enable\_authorization](#input\_enable\_authorization) | Is authorization rule enabled? | `bool` | `false` | no |
| <a name="input_eventhub_consumer_group_name"></a> [eventhub\_consumer\_group\_name](#input\_eventhub\_consumer\_group\_name) | Specifies the name of the EventHub Consumer Group resource. | `string` | n/a | yes |
| <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name) | Specifies the name of the EventHub resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_eventhub_namespace_name"></a> [eventhub\_namespace\_name](#input\_eventhub\_namespace\_name) | Specifies the name of the EventHub Namespace. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_listen"></a> [listen](#input\_listen) | Does this Authorization Rule have permissions to Listen to the Event Hub? | `string` | `true` | no |
| <a name="input_manage"></a> [manage](#input\_manage) | Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is true - both listen and send must be too. | `string` | `false` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | Specifies the number of days to retain the events for this Event Hub. | `number` | `90` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | Specifies the current number of shards on the Event Hub.`partition_count` cannot be changed unless Eventhub Namespace SKU is `Premium`. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the EventHub's parent Namespace exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_send"></a> [send](#input\_send) | Does this Authorization Rule have permissions to Send to the Event Hub | `string` | `true` | no |
| <a name="input_status"></a> [status](#input\_status) | Specifies the status of the Event Hub resource. Possible values are Active, Disabled and SendDisabled. Defaults to Active. | `string` | `"Active"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consumer_group_id"></a> [consumer\_group\_id](#output\_consumer\_group\_id) | The ID of the EventHub Consumer Group. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the EventHub. |
| <a name="output_partition_ids"></a> [partition\_ids](#output\_partition\_ids) | The identifiers for partitions created for Event Hubs. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The Primary Connection String for the Event Hubs authorization Rule. |
| <a name="output_primary_key"></a> [primary\_key](#output\_primary\_key) | The Primary Key for the Event Hubs authorization Rule. |
| <a name="output_secondary_connection_string"></a> [secondary\_connection\_string](#output\_secondary\_connection\_string) | The Secondary Connection String for the Event Hubs authorization Rule. |
| <a name="output_secondary_key"></a> [secondary\_key](#output\_secondary\_key) | The Secondary Key for the Event Hubs authorization Rule. |
<!-- END_TF_DOCS -->
