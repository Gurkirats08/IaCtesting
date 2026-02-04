locals {
  self_hosted_integration_ids = [for ir_k, ir_v in azurerm_data_factory_integration_runtime_self_hosted.integration_runtime : ir_v.id]
  azure_integration_ids       = [for ir_k, ir_v in azurerm_data_factory_integration_runtime_azure.integration_runtime : ir_v.id]
  azure_ssis_integration_ids  = [for ir_k, ir_v in azurerm_data_factory_integration_runtime_azure_ssis.integration_runtime : ir_v.id]

  integration_runtime_id = try(concat(local.self_hosted_integration_ids, local.azure_integration_ids, local.azure_ssis_integration_ids), null)
  temp_list_ip           = var.integration_runtime_shir
  extensionScriptPath    = "../gatewayInstall.ps1"
  ## Generating a Map of all the shir's where we need to run the custom script on the virtual machine ##
  temp_list = compact([for ir_k, ir_v in local.temp_list_ip : try(ir_v.run_cse, false) == true ? "${ir_v.virtual_machine_id}||${ir_k}" : null])
  shir_cse  = { for ir in local.temp_list : split("||", ir)[1] => split("||", ir)[0] }
}
