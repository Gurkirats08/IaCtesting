<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.25 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | n/a |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.25 |
| <a name="provider_time"></a> [time](#provider\_time) | ~>0.9 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.kerstorage](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_account_network_rules.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_blob.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa. | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow public access to all nested items in the storage account. | `bool` | `false` | no |
| <a name="input_allowed_headers"></a> [allowed\_headers](#input\_allowed\_headers) | A list of headers that are allowed to be a part of the cross-origin request | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_allowed_methods"></a> [allowed\_methods](#input\_allowed\_methods) | A list of http methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH. | `list(string)` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "MERGE",<br>  "POST",<br>  "OPTIONS",<br>  "PUT",<br>  "PATCH"<br>]</pre> | no |
| <a name="input_allowed_origins"></a> [allowed\_origins](#input\_allowed\_origins) | A list of origin domains that will be allowed by CORS. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_blobs"></a> [blobs](#input\_blobs) | Map of the Storage Blobs in the Containers.<br></br><ul><li>`name`: The name of the storage blob. Must be unique within the storage container the blob is located, </li><li>`storage_container_name`: The name of the storage container in which this blob should be created, </li><li>`type`: The type of the storage blob to be created. Possible values are `Append`, `Block` or `Page`, </li><li>`size`: Used only for page blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512, </li><li>`content_type`: The content type of the `storage blob`. Cannot be defined if `source_uri` is defined, </li><li>`parallelism`: The number of workers per CPU core to run for concurrent uploads, </li><li>`source_uri`: The URI of an existing blob, or a file in the Azure File service, to use as the source contents for the blob to be created, </li><li>`metadata`: A map of custom blob metadata. | <pre>map(object({<br>    name                   = string<br>    storage_container_name = string<br>    type                   = string<br>    size                   = number<br>    content_type           = string<br>    parallelism            = number<br>    source_uri             = string<br>    metadata               = map(any)<br>  }))</pre> | `{}` | no |
| <a name="input_change_feed_enabled"></a> [change\_feed\_enabled](#input\_change\_feed\_enabled) | Is the blob service properties for change feed events enabled? | `bool` | `true` | no |
| <a name="input_container_delete_retention_policy_days"></a> [container\_delete\_retention\_policy\_days](#input\_container\_delete\_retention\_policy\_days) | Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7 | `number` | `7` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Map of the Containers in the Storage Account.<br></br><ul><li>`name`: The name of the Container which should be created within the Storage Account. | <pre>map(object({<br>    name = string<br>  }))</pre> | `{}` | no |
| <a name="input_content_type"></a> [content\_type](#input\_content\_type) | Specifies the content type for the Key Vault Secret. | `string` | `"set"` | no |
| <a name="input_cors_rule_enabled"></a> [cors\_rule\_enabled](#input\_cors\_rule\_enabled) | Is cors rule enabled? | `bool` | `false` | no |
| <a name="input_delete_retention_policy_days"></a> [delete\_retention\_policy\_days](#input\_delete\_retention\_policy\_days) | Specifies the number of days that the blob should be retained, between '1' and '365'. Defaults to 7 | `number` | `7` | no |
| <a name="input_domainGuid"></a> [domainGuid](#input\_domainGuid) | Active directory domain id to be used for authentication. | `string` | `"a2875a11-9ba9-4ccd-a85b-8cf7717b496c"` | no |
| <a name="input_domainName"></a> [domainName](#input\_domainName) | Active directory domain name to be used for authentication. | `string` | `"domain.local"` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created. | `string` | `null` | no |
| <a name="input_enable_kerberos"></a> [enable\_kerberos](#input\_enable\_kerberos) | Is kerberos enabled? | `bool` | `false` | no |
| <a name="input_exposed_headers"></a> [exposed\_headers](#input\_exposed\_headers) | A list of response headers that are exposed to CORS clients. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_file_share_delete_retention_policy_days"></a> [file\_share\_delete\_retention\_policy\_days](#input\_file\_share\_delete\_retention\_policy\_days) | Specifies the number of days that the azurerm\_storage\_share should be retained, between 1 and 365 days. Defaults to 7 | `number` | `7` | no |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | Map of the Storage File Shares.<br></br><ul><li>`name`: The name of the share. Must be unique within the storage account where the share is located, </li><li>`quota`: The maximum size of the share, in gigabytes. For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB), </li><li>`enabled_protocol`: The protocol used for the share. Possible values are `SMB` and `NFS`, </li><li>`metadata`: A mapping of MetaData for this File Share. | <pre>map(object({<br>    name             = string<br>    quota            = number<br>    enabled_protocol = string<br>    metadata         = map(any)<br>    access_tier      = string<br>  }))</pre> | `{}` | no |
| <a name="input_key_expiration_date"></a> [key\_expiration\_date](#input\_key\_expiration\_date) | Expiration UTC datetime (YYYY-mm-dd'T'HH:MM:SS'Z') for key. | `string` | `null` | no |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key\_type is RSA or RSA-HSM. Changing this forces a new resource to be created. | `string` | `"4096"` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created. | `string` | `"RSA"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the existing Key vault to store the Customer Managed Key for Encryption. | `string` | n/a | yes |
| <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled) | Set to `true`, the Storage Account will be enabled for large file shares. | `bool` | `false` | no |
| <a name="input_last_access_time_enabled"></a> [last\_access\_time\_enabled](#input\_last\_access\_time\_enabled) | Is the last access time based tracking enabled? | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_max_age_in_seconds"></a> [max\_age\_in\_seconds](#input\_max\_age\_in\_seconds) | The number of seconds the client should cache a preflight response. | `number` | `200` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version for the storage account. Possible values are 'TLS1\_0', 'TLS1\_1', and 'TLS1\_2' | `string` | `"TLS1_2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group. | `string` | n/a | yes |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Networking settings for the Storage Account:<br></br><ul><li>`default_action`: The Default Action to use when no rules match ip\_rules / virtual\_network\_subnet\_ids. Possible values are `"Allow"` and `"Deny"`,</li><li>`ip_rules`: One or more <b>Public IP Addresses or CIDR Blocks</b> which should be able to access the Storage Account,</li><li>`virtual_network_subnet_ids`: One or more Subnet IDs which should be able to access the Storage Account.</li></ul> | <pre>object({<br>    default_action             = string<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | <pre>{<br>  "default_action": "Deny",<br>  "ip_rules": [],<br>  "virtual_network_subnet_ids": []<br>}</pre> | no |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | Set to `true`, the `NFSV3` protocol will be enabled. | `bool` | `false` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | the ID of the azure resource in which this resource is created.<br>   It supports different kinds of deployment scope for top level resources:<br><br>   resource group scope: parent\_id should be the ID of a resource group<br><br>   management group scope: parent\_id should be the ID of a management group<br><br>   extension scope: parent\_id should be the ID of the resource you're adding the extension to.<br><br>   subscription scope: parent\_id should be like /subscriptions/00000000-0000-0000-0000-000000000000<br><br>   tenant scope: parent\_id should be /<br><br>   For child level resources, the parent\_id should be the ID of its parent resource.<br>   Ex: subnet resource's parent\_id is the ID of the vnet. | `string` | `null` | no |
| <a name="input_persist_access_key"></a> [persist\_access\_key](#input\_persist\_access\_key) | Set `true` to store storage access key in `key vault`. | `bool` | `true` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the public network access is enabled? | `bool` | `false` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Map of the Storage Queues.<br></br><ul><li>`name`: The name of the Queue which should be created within the Storage Account. Must be unique within the storage account the queue is located, </li><li>`metadata`: A mapping of MetaData which should be assigned to this Storage Queue. | <pre>map(object({<br>    name     = string<br>    metadata = map(any)<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the storage account. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role\_definition\_id. | `string` | `"Key Vault Crypto Service Encryption User"` | no |
| <a name="input_secret_expiration_date"></a> [secret\_expiration\_date](#input\_secret\_expiration\_date) | Expiration UTC datetime (YYYY-mm-dd'T'HH:MM:SS'Z') for secret. | `string` | `null` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). | `bool` | `false` | no |
| <a name="input_soft_delete_blob_enabled"></a> [soft\_delete\_blob\_enabled](#input\_soft\_delete\_blob\_enabled) | Is the soft delete for blob enabled? | `bool` | `false` | no |
| <a name="input_soft_delete_container_enabled"></a> [soft\_delete\_container\_enabled](#input\_soft\_delete\_container\_enabled) | Is the soft delete for container enabled? | `bool` | `false` | no |
| <a name="input_soft_delete_share_enabled"></a> [soft\_delete\_share\_enabled](#input\_soft\_delete\_share\_enabled) | Is the soft delete for container enabled? | `bool` | `false` | no |
| <a name="input_static_website"></a> [static\_website](#input\_static\_website) | A static\_website block as defined. It can only be set when the account\_kind is set to StorageV2 or BlockBlobStorage. | <pre>object({<br>    index_document     = string<br>    error_404_document = string<br>  })</pre> | `null` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | Map of the Storage Tables.<br></br><ul><li>`name`: The name of the storage table. Must be unique within the storage account the table is located. | <pre>map(object({<br>    name = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Is versioning enabled? | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blob_ids"></a> [blob\_ids](#output\_blob\_ids) | The generated IDs for the Blobs. |
| <a name="output_blob_urls"></a> [blob\_urls](#output\_blob\_urls) | The generated URLs of the Blobs. |
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | The generated IDs for the Containers. |
| <a name="output_file_share_ids"></a> [file\_share\_ids](#output\_file\_share\_ids) | The generated IDs of the File shares. |
| <a name="output_file_share_urls"></a> [file\_share\_urls](#output\_file\_share\_urls) | The generated URLs of the File shares. |
| <a name="output_id"></a> [id](#output\_id) | The id of the resource created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource created. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key of the storage account created. |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | The endpoint URL for blob storage in the primary location. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The primary connection string of the storage account created. |
| <a name="output_queue_ids"></a> [queue\_ids](#output\_queue\_ids) | The generated IDs of the Queue. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | The secondary access key of the storage account created. |
| <a name="output_secondary_blob_endpoint"></a> [secondary\_blob\_endpoint](#output\_secondary\_blob\_endpoint) | The endpoint URL for blob storage in the secondary location. |
| <a name="output_secondary_connection_string"></a> [secondary\_connection\_string](#output\_secondary\_connection\_string) | The secondary connection string of the storage account created. |
| <a name="output_storage_identity_principal_id"></a> [storage\_identity\_principal\_id](#output\_storage\_identity\_principal\_id) | The Principal ID for the Service Principal associated with the Identity of this Storage Account |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | The generated IDs of the Table. |
<!-- END_TF_DOCS -->

## Notes
- Terraform uses Shared Key Authorisation to provision Storage Containers, Blobs and other items - when Shared Key Access is disabled, you will need to enable the [storage_use_azuread](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#storage_use_azuread) flag in the Provider block to use Azure AD for authentication, however not all Azure Storage services support Active Directory authentication.
