variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  type        = list(string)
  description = "(Required) The address prefixes to use for the subnet."
}

variable "subnet_name" {
  type        = string
  description = "The subnet name."
}

variable "delegation_name" {
  type        = string
  description = "A name for this delegation."
  default     = null
}

variable "service_delegation_name" {
  type        = string
  description = "The name of service to delegate to. Possible values include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments and PaloAltoNetworks.Cloudngfw/firewalls."
  default     = null
}

variable "service_delegation_actions" {
  type        = list(string)
  description = "A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
  default     = null
}

variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web."
  default     = null
}

// variable "private_endpoint_network_policies_enabled" {
//   type        = string
//   description = "Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
//   default     = false
// }

variable "private_endpoint_network_policies" {
  type        = string
  description = "Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     =  "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  type        = string
  description = "Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     = false
}





variable "route_table_id" {
  type        = string
  description = "Route table id to create a route table association."
  default     = null
}

variable "network_security_group_id" {
  type        = string
  description = "Route table id to create a NSG association."
  default     = null
}
