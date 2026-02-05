data "azurerm_client_config" "current" {}

# Multiple resource group's

module "terraform-azurerm-resource-group" {
  for_each            = var.resourceGroups
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\resourcegroup\\v1.0"
  location            = var.location
  resource_group_name = each.value.name
  tags                = var.tags
}


#----------------------------------------------------------------------------------

# resource "null_resource" "backup_vault" {
#   provisioner "local-exec" {
#     command = <<EOT

#     az config set extension.dynamic_install_allow_preview=true

#     keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.hsm_name} --name ${var.hsm_key_name}  --query [key.kid] -o tsv)

#     az dataprotection backup-vault create --vault-name ${var.backup_vault_name} --resource-group ${var.resourceGroups["addsRG"].name} --location ${var.mainLocation} --storage-setting "[{type:'LocallyRedundant',datastore-type:'VaultStore'}]" --type "SystemAssigned,UserAssigned" --user-assigned-identities '{"/subscriptions/${var.identity_sub_id}/resourceGroups/${var.resourceGroups["addsRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.managedIdentity}":{}}' --cmk-encryption-key-uri $keyVaultKeyUrl --cmk-encryption-state "Enabled" --cmk-identity-type "UserAssigned" --cmk-infrastructure-encryption "Enabled" --cmk-user-assigned-identity-id  "/subscriptions/${var.identity_sub_id}/resourceGroups/${var.resourceGroups["addsRG"].name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.managedIdentity}" --immutability-state Locked
#     EOT
#   }
#   lifecycle {
#     ignore_changes = [triggers]
#   }
#   depends_on = [module.identity_user_assigned_identity]

# }






module "identity_user_assigned_identity" {
  source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
  name                = "ua-idnt-test-31"
  location            = "uaenorth"
  resource_group_name = "rg-idnt-test-31"
  depends_on          = [module.terraform-azurerm-resource-group]
}



resource "null_resource" "create_hsm_key" {
  # triggers = {
  #   always_run = timestamp()
  # }
  provisioner "local-exec" {

    command = <<EOT
      az keyvault key create --exportable true --hsm-name ${var.hsm_name} --kty RSA-HSM --name "hsm-key-copy01" --policy "./public_SKR_policy.json" --not-before "2024-03-20T13:00:00Z" --expires "2026-03-20T13:00:00Z"
    EOT
  }
  lifecycle {
    ignore_changes = [triggers]
  }
}

locals {
  role_assignment1_uuid           = uuid()
  role_assignment2_uuid           = uuid()
  user_assigned_identity_id       = module.identity_user_assigned_identity.id
  principal_id                    = module.identity_user_assigned_identity.principal_id
}

# Step 2: Assign Roles for Managed HSM Key Permissions
resource "null_resource" "assign_hsm_roles" {
  # triggers = {
  #   always_run = timestamp()
  # }
  provisioner "local-exec" {
    command = <<EOT
      az keyvault role assignment create --role "Managed HSM Crypto User" --hsm-name Sec-hsm01  --scope "/keys/${var.hsm_key_name}" --assignee-object-id ${local.principal_id} --name ${local.role_assignment1_uuid}
      az keyvault role assignment create --role "Managed HSM Crypto Service Encryption User" --hsm-name Sec-hsm01  --scope "/keys/${var.hsm_key_name}" --assignee-object-id ${local.principal_id} --name ${local.role_assignment2_uuid}
    EOT
  }
  depends_on = [null_resource.create_hsm_key]
  lifecycle {
    ignore_changes = [triggers]
  }
}

# Step 3: Create the Disk Encryption Set (DES)
# resource "null_resource" "create_des" {
#   # triggers = {
#   #   always_run = timestamp()
#   # }
#   provisioner "local-exec" {
#     command = <<EOT
#       keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.hsm_name} --name ${var.hsm_key_name} --query [key.kid] -o tsv)

#       az disk-encryption-set create -n "des-rotate-05" -l uaenorth -g ${var.resourceGroups.addsRG.name} --key-url $keyVaultKeyUrl --encryption-type ConfidentialVmEncryptedWithCustomerKey --mi-system-assigned false --mi-user-assigned ${local.user_assigned_identity_id}
#     EOT
#   }
#   depends_on = [null_resource.assign_hsm_roles, module.terraform-azurerm-resource-group] 
#   # lifecycle {
#   #   ignore_changes = [triggers]
#   # }

# }


module "app_recovery_service_vault" {
  for_each                     = var.appRecoveryServiceVault
  source                       = "..\\..\\terraform-modules-hub\\terraform-modules\\recoveryservicevault"
  recovery_services_vault_name = each.value.recovery_services_vault_name
  location                     = var.location
  resource_group_name          = each.value.resource_group_name
  sku                          = each.value.sku
  identity_type                = each.value.identity_type
  identity_ids                 = [module.identity_user_assigned_identity.id]
  depends_on                   = [module.terraform-azurerm-resource-group, module.identity_user_assigned_identity]
}

# #VM Backup policy
module "vm_backup_policy_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\vmbackuppolicy\\v1.0"
  for_each                = var.vm_backup_policies
  backup_policy_name      = each.value.backup_policy_name
  recovery_vault_name     = each.value.recovery_vault_name
  rsv_resource_group_name = each.value.rsv_resource_group_name
  backup_frequency        = each.value.backup_frequency
  backup_time             = each.value.backup_time
  retention_daily_count   = each.value.retention_daily_count
  vm_name                 = each.value.vm_name
  vm_resource_group_name  = each.value.vm_resource_group_name
  depends_on              = [module.app_recovery_service_vault]
}

##


# #RSV encryption
locals {
  encryption_key_id               = "https://sec-hsm01.managedhsm.azure.net/keys/idnt-hsm-key-02"
  rsv_name                        = var.appRecoveryServiceVault["rsv1"].recovery_services_vault_name
  identity_user_assigned_identity = module.identity_user_assigned_identity.id
}

resource "null_resource" "rsv_encryption" {
  provisioner "local-exec" {
    command = "az backup vault encryption update --encryption-key-id ${local.encryption_key_id} --mi-user-assigned ${local.identity_user_assigned_identity} --resource-group ${var.rsv_rg} --name ${local.rsv_name} --infrastructure-encryption Enabled"
  }
  lifecycle {
    ignore_changes = [triggers]
  }
  depends_on = [module.app_recovery_service_vault]

}



#Linux VM

module "linux_vm_module" {
  source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\linuxvm\\v1.0-acc"
  location                = var.mainLocation
  administrator_user_name = var.adminUser
  linux_vms               = var.sharedservicesLinuxVms
  resource_group_name     = "rg-idnt-test-31"
  disk_encryption_set_id  = "/subscriptions/a03bd7fd-5bf3-4ea3-95be-7babd65eb73e/resourceGroups/rg-adds-idnt-prd-phi-sea-001/providers/Microsoft.Compute/diskEncryptionSets/sec-team"
  identity_type           = "UserAssigned"
  identity_ids            = module.identity_user_assigned_identity.id
  depends_on              = [ module.terraform-azurerm-resource-group] //,module.sharedservices_disk_encryption_set]
}


#-----------------------------------------------------------------------------------------
#-----------------------------Non-CVM deployement------------------------



# locals {
#   user_assigned_identity_id = module.identity_user_assigned_identity.id
# }

# data "azurerm_key_vault_managed_hardware_security_module" "hsm" {
#   provider            = azurerm.securitySub
#   name                = var.hsm_name
#   resource_group_name = var.hsm_resource_group
# }

# resource "azurerm_key_vault_managed_hardware_security_module_key" "hsm-key" {
#   provider        = azurerm.securitySub
#   managed_hsm_id  = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   name            = var.hsm_key_name
#   key_type        = "RSA-HSM"
#   key_size        = 2048
#   key_opts        = ["sign", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify"]
#   expiration_date = "2026-09-19T23:59:59Z"
#   not_before_date = "2024-09-20T00:00:00Z"
#   #depends_on      = [data.azurerm_key_vault_managed_hardware_security_module.hsm, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
#   depends_on = [data.azurerm_key_vault_managed_hardware_security_module.hsm]
# }

# resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "HSM_Crypto_Service_Encryption_User" {
#   provider           = azurerm.securitySub
#   managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   name               = uuid()
#   scope              = "/keys/${var.hsm_key_name}"
#   role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/33413926-3206-4cdd-b39a-83574fe37a17"
#   principal_id       = module.identity_user_assigned_identity.principal_id
#   lifecycle {
#     ignore_changes = [name, principal_id]
#   }
#   depends_on = [module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
# }


# resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "Managed_HSM_Crypto_User" {
#   provider           = azurerm.securitySub
#   managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   name               = uuid()
#   scope              = "/keys/${var.hsm_key_name}"
#   role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b"
#   principal_id       = module.identity_user_assigned_identity.principal_id
#   lifecycle {
#     ignore_changes = [name, principal_id]
#   }
#   depends_on = [module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key]
# }




# #---------------------------------------------------------------------------------------------------

# module "conn_disk_encryption_set" {
#   source                   = "..\\..\\terraform-modules-hub\\terraform-modules\\diskencryptionset\\v1.0"
#   disk_encryption_set_name = "sec-team23"
#   location                 = "uaenorth"
#   resource_group_name      = "rg-idnt-test-23"
#   key_id                   = resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key.versioned_id
#   key_vault_id             = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   tenant_id                = data.azurerm_client_config.current.tenant_id
#   user_assigned_identity   = [module.identity_user_assigned_identity.id]

#   depends_on = [resource.azurerm_key_vault_managed_hardware_security_module_key.hsm-key, module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.HSM_Crypto_Service_Encryption_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
# }

# #Data Disk
# module "app_data_disk" {
#   for_each               = var.appDataDisks
#   source                 = "..\\..\\terraform-modules-hub\\terraform-modules\\datadisk\\v1.0"
#   resource_group         = each.value.resource_group_name
#   location               = var.mainLocation
#   disk_name              = each.value.disk_name
#   storage_account_type   = each.value.storage_account_type
#   disk_size_gb           = each.value.disk_size_gb
#   disk_encryption_set_id = module.conn_disk_encryption_set.disk_encryption_set_id
#   depends_on             = [module.terraform-azurerm-resource-group, module.conn_disk_encryption_set]
# }



# # HSM Key, role assignments and DES for OS Disk through CLI

# module "os_user_assigned_identity" {
#   source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
#   name                = "ua-os-test-23"
#   location            = "uaenorth"
#   resource_group_name = "rg-idnt-test-23"
#   depends_on          = [module.terraform-azurerm-resource-group]
# }

# # Step 1: Create the HSM Key
# resource "null_resource" "create_hsm_key" {
#   # triggers = {
#   #   always_run = timestamp()
#   # }
#   provisioner "local-exec" {

#     command = <<EOT
#       az keyvault key create --exportable true --hsm-name ${var.hsm_name} --kty RSA-HSM --name "idnt-os-key-test-23" --policy "./public_SKR_policy.json" --not-before "2024-03-20T13:00:00Z" --expires "2026-03-20T13:00:00Z"
#     EOT
#   }
#   lifecycle {
#     ignore_changes = [triggers]
#   }
# }

# locals {
#   role_assignment1_uuid   = uuid()
#   role_assignment2_uuid   = uuid()
#   os_assigned_identity_id = module.os_user_assigned_identity.id
#   principal_id            = module.os_user_assigned_identity.principal_id
# }

# # Step 2: Assign Roles for Managed HSM Key Permissions
# resource "null_resource" "assign_hsm_roles" {
#   # triggers = {
#   #   always_run = timestamp()
#   # }
#   provisioner "local-exec" {
#     command = <<EOT
#       az keyvault role assignment create --role "Managed HSM Crypto User" --hsm-name Sec-hsm01  --scope "/keys/idnt-os-key-test-23" --assignee-object-id ${local.principal_id} --name ${local.role_assignment1_uuid}
#       az keyvault role assignment create --role "Managed HSM Crypto Service Encryption User" --hsm-name Sec-hsm01  --scope "/keys/idnt-os-key-test-23" --assignee-object-id ${local.principal_id} --name ${local.role_assignment2_uuid}
#     EOT
#   }
#   depends_on = [null_resource.create_hsm_key]
#   lifecycle {
#     ignore_changes = [triggers]
#   }
# }

# # Step 3: Create the Disk Encryption Set (DES)
# resource "null_resource" "create_des" {
#   # triggers = {
#   #   always_run = timestamp()
#   # }
#   provisioner "local-exec" {
#     command = <<EOT
#       keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.hsm_name} --name "idnt-os-key-test-23" --query [key.kid] -o tsv)

#       az disk-encryption-set create -n "idnt-test-des01" -l uaenorth -g "rg-idnt-test-23" --key-url $keyVaultKeyUrl --enable-auto-key-rotation false --encryption-type ConfidentialVmEncryptedWithCustomerKey --mi-system-assigned false --mi-user-assigned ${local.os_assigned_identity_id}
#     EOT
#   }
#   depends_on = [null_resource.assign_hsm_roles]
#   lifecycle {
#     ignore_changes = [triggers]
#   }
# }





# virtual machine deployment

# module "identity_virtual_machine_module" {
#   source = "..\\..\\terraform-modules-hub\\terraform-modules\\windowsvm\\v2.0-nonacc"
#   location                = var.location
#   administrator_user_name = var.adminUser
#   windows_vms             = var.identityVirtualMachines
#   disk_encryption_set_id  = "/subscriptions/${var.identity_sub_id}/resourceGroups/rg-idnt-test-01/providers/Microsoft.Compute/diskEncryptionSets/sec-team"
#   resource_group_name     = "rg-idnt-test-01"
#   identity_type           = "UserAssigned"
#   identity_ids            = module.identity_user_assigned_identity.id
#   depends_on              = [module.conn_disk_encryption_set, module.identity_user_assigned_identity,resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
# }

# module "azurerm_virtual_machine_extension_guest_attestation" {
#   for_each                   = var.identityVirtualMachines
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   name                       = "GuestAttestation"
#   virtual_machine_name       = each.value.vmName
#   resource_group_name        = "rg-idnt-test-01"
#   publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.identity_virtual_machine_module]
# }


# module "azurerm_virtual_machine_extension_GC" {
#   for_each                   = var.identityVirtualMachines
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   name                       = "AzurePolicyforWindows"
#   resource_group_name        = var.resourceGroups.addsRG.name
#   automatic_upgrade_enabled  = true
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.GuestConfiguration"
#   type                       = "ConfigurationforWindows"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = "true"
#   depends_on                 = [module.identity_virtual_machine_module]
# }

# module "azurerm_virtual_machine_extension_DA" {
#   for_each                   = var.identityVirtualMachines
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   name                       = "daagent"
#   resource_group_name        = var.resourceGroups.addsRG.name
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
#   type                       = "DependencyAgentWindows"
#   type_handler_version       = "9.9"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.identity_virtual_machine_module]
# }


#-----------------------------------------------------------------------------------------









#-----------------------------CVM deployement------------------------
# module "identity_user_assigned_identity" {
#   source              = "..\\..\\terraform-modules-hub\\terraform-modules\\userassignedidentity\\v1.0"
#   name                = "idnt-ua-01-test"
#   location            = "uaenorth"
#   resource_group_name = "rg-idnt-test-01"
#   depends_on          = [module.terraform-azurerm-resource-group]
# }

# locals {
#   user_assigned_identity_id = module.identity_user_assigned_identity.id
# }

# data "azurerm_key_vault_managed_hardware_security_module" "hsm" {
#   provider            = azurerm.securitySub
#   name                = var.hsm_name
#   resource_group_name = var.hsm_resource_group
# }



# resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "role_assignment" {
#   provider           = azurerm.securitySub
#   managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   name               = uuid()
#   scope              = "/keys"
#   role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/33413926-3206-4cdd-b39a-83574fe37a17"
#   principal_id       = module.identity_user_assigned_identity.principal_id
#   lifecycle {
#     ignore_changes = [name, principal_id]
#   }
#   depends_on = [module.identity_user_assigned_identity, data.azurerm_key_vault_managed_hardware_security_module.hsm]
# }


# resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "Managed_HSM_Crypto_User" {
#   provider           = azurerm.securitySub
#   managed_hsm_id     = data.azurerm_key_vault_managed_hardware_security_module.hsm.id
#   name               = uuid()
#   scope              = "/keys"
#   role_definition_id = "/Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b"
#   principal_id       = module.identity_user_assigned_identity.principal_id
#   lifecycle {
#     ignore_changes = [name, principal_id]
#   }
#   depends_on = [module.identity_user_assigned_identity, data.azurerm_key_vault_managed_hardware_security_module.hsm]
# }


# resource "null_resource" "des" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az keyvault key create --exportable true --hsm-name ${var.hsm_name} --kty RSA-HSM --name ${var.hsm_key_name} --policy "./public_SKR_policy.json" --not-before "2024-03-20T13:00:00Z" --expires "2026-03-20T13:00:00Z"

#       keyVaultKeyUrl=$(az keyvault key show --hsm-name ${var.hsm_name} --name ${var.hsm_key_name} --query [key.kid] -o tsv)

#       az disk-encryption-set create -n sec-team -l uaenorth  -g ${var.resourceGroups.addsRG.name} --key-url $keyVaultKeyUrl --enable-auto-key-rotation false --encryption-type ConfidentialVmEncryptedWithCustomerKey  --mi-system-assigned false --mi-user-assigned ${local.user_assigned_identity_id}
#     EOT
#   }
#   triggers = {
#     # hsm_name                  = var.hsm_name
#     # hsm_key_name              = var.hsm_key_name
#     # user_assigned_identity_id = local.user_assigned_identity_id
#     unique_value = "1"
#   }
#   depends_on = [resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, local.user_assigned_identity_id]
# }

# resource "null_resource" "scope_change" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az keyvault set-policy --name ${var.hsm_name} --hsm-name ${var.hsm_name} --object-id ${module.identity_user_assigned_identity.principal_id} --key-permissions wrapKey unwrapKey get
#     EOT
#   }
#   triggers = {
#     unique_value = "1"
#   }
#   depends_on = [null_resource.des, module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.role_assignment]

# }

# #---------------------------------------------------------------------------------------------------
# # virtual machine deployment

# module "identity_virtual_machine_module" {
#   source = "..\\..\\terraform-modules-hub\\terraform-modules\\windowsvm\\v1.0-acc"
#   # for_each                = var.identityVirtualMachines
#   location                = var.location
#   administrator_user_name = var.adminUser
#   windows_vms             = var.identityVirtualMachines
#   disk_encryption_set_id  = "/subscriptions/${var.identity_sub_id}/resourceGroups/${var.resourceGroups.addsRG.name}/providers/Microsoft.Compute/diskEncryptionSets/${var.disk_encryption_set_name}"
#   resource_group_name     = var.resourceGroups.addsRG.name
#   identity_type           = "UserAssigned"
#   identity_ids            = module.identity_user_assigned_identity.id
#   depends_on              = [null_resource.des, module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
# }


# # #Deallocating the VM------------------

# resource "null_resource" "deallocation" {
#   triggers = {
#     unique_value = "1"
#   }
#   for_each = { for vm in var.identityVirtualMachines : vm.vmName => vm }
#   provisioner "local-exec" {
#     interpreter = ["bash", "-c"]
#     command     = "az vm deallocate --resource-group ${each.value.resourceGroupName} --name ${each.value.vmName}"
#   }
#   depends_on = [module.identity_virtual_machine_module, module.azurerm_virtual_machine_extension_guest_attestation, module.antimalware_vm_extension_module_Sec]
# }

# # # Enabling encryption at host level-------------------
# resource "null_resource" "encryptionAtHost" {
#   for_each = { for vm in var.identityVirtualMachines : vm.vmName => vm }
#   provisioner "local-exec" {
#     command = <<EOT
#       az vm update -n ${each.value.vmName} -g ${var.resourceGroups.addsRG.name} --set securityProfile.encryptionAtHost=true --subscription ${var.identity_sub_id}

#       EOT
#   }
#   triggers = {
#     unique_value = "1"
#   }
#   depends_on = [module.identity_virtual_machine_module, null_resource.deallocation, module.azurerm_virtual_machine_extension_guest_attestation, module.antimalware_vm_extension_module_Sec]
# }


# # # Starting the VM again after enabling encryption-------------
# resource "null_resource" "vm_start" {
#   for_each = { for vm in var.identityVirtualMachines : vm.vmName => vm }
#   provisioner "local-exec" {
#     command = <<EOT
#       az vm start --resource-group ${var.resourceGroups.addsRG.name} --name ${each.value.vmName} --subscription ${var.identity_sub_id}
#     EOT
#   }
#   triggers = {
#     unique_value = "1"
#   }
#   depends_on = [null_resource.encryptionAtHost]
# }



# # ##VM Extensions
# module "antimalware_vm_extension_module_Sec" {
#   for_each                   = var.identityVirtualMachines
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   resource_group_name        = var.resourceGroups.addsRG.name
#   name                       = "IaaSAntimalware"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Security"
#   type                       = "IaaSAntimalware"
#   type_handler_version       = "1.3"
#   auto_upgrade_minor_version = true
#   automatic_upgrade_enabled  = false
#   settings                   = <<SETTINGS
#   {
#       "AntimalwareEnabled": true,
#       "RealtimeProtectionEnabled": "true",
#       "ScheduledScanSettings": {
#         "isEnabled": "true",
#         "day": "7",
#         "time": "120",
#         "scanType": "Quick"
#       }
#   }
#   SETTINGS
#   depends_on                 = [module.identity_virtual_machine_module]
#   tags                       = var.tags
# }



# # module "azurerm_virtual_machine_extension_GC" {
# #   for_each                   = var.identityVirtualMachines
# #   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
# #   name                       = "AzurePolicyforWindows"
# #   resource_group_name        = var.resourceGroups.addsRG.name
# #   automatic_upgrade_enabled  = true
# #   virtual_machine_name       = each.value.vmName
# #   publisher                  = "Microsoft.GuestConfiguration"
# #   type                       = "ConfigurationforWindows"
# #   type_handler_version       = "1.0"
# #   auto_upgrade_minor_version = "true"
# #   depends_on                 = [module.identity_virtual_machine_module]
# # }

# # module "azurerm_virtual_machine_extension_DA" {
# #   for_each                   = var.identityVirtualMachines
# #   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
# #   name                       = "daagent"
# #   resource_group_name        = var.resourceGroups.addsRG.name
# #   virtual_machine_name       = each.value.vmName
# #   publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
# #   type                       = "DependencyAgentWindows"
# #   type_handler_version       = "9.9"
# #   automatic_upgrade_enabled  = false
# #   auto_upgrade_minor_version = true
# #   depends_on                 = [module.identity_virtual_machine_module]
# # }


# module "azurerm_virtual_machine_extension_guest_attestation" {
#   for_each                   = var.identityVirtualMachines
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   name                       = "GuestAttestation"
#   virtual_machine_name       = each.value.vmName
#   resource_group_name        = var.resourceGroups.addsRG.name
#   publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.identity_virtual_machine_module]
# }

# #----------------------
# module "linux_vm_module" {
#   source                  = "..\\..\\terraform-modules-hub\\terraform-modules\\linuxvm\\v1.0-acc"
#   location                = var.mainLocation
#   administrator_user_name = var.adminUser
#   linux_vms               = var.sharedservicesLinuxVms
#   resource_group_name     = var.resource_group_name
#   disk_encryption_set_id  = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/diskEncryptionSets/${var.disk_encryption_set_name}"
#   identity_type           = "UserAssigned"
#   identity_ids            = module.identity_user_assigned_identity.id
#   depends_on              = [null_resource.des, module.identity_user_assigned_identity, resource.azurerm_key_vault_managed_hardware_security_module_role_assignment.Managed_HSM_Crypto_User]
# }

# #Deallocating the VM------------------

# resource "null_resource" "linux_deallocation" {
#   for_each = { for vm in var.sharedservicesLinuxVms : vm.vmName => vm }
#   provisioner "local-exec" {
#     command = "az vm deallocate --resource-group ${each.value.resourceGroupName} --name ${each.value.vmName}"
#   }
#   triggers = {
#     unique_value = "1"
#   }
#   depends_on = [module.linux_vm_module, module.linux_guest_attestation, module.linux_daagent_vm_extension_module]
# }

# #Enabling encryption on the VM -----------------

# resource "null_resource" "linux_encryptionAtHost" {
#   for_each = { for vm in var.sharedservicesLinuxVms : vm.vmName => vm }
#   provisioner "local-exec" {
#     command = "az vm update -n ${each.value.vmName} -g ${each.value.resourceGroupName} --set securityProfile.encryptionAtHost=true"
#   }
#   lifecycle {
#     ignore_changes = [triggers]
#   }
#   depends_on = [null_resource.linux_deallocation, module.linux_vm_module]
# }

# # Starting the VM again after enabling encryption-------------

# resource "null_resource" "linux_vm_start" {
#   for_each = { for vm in var.sharedservicesLinuxVms : vm.vmName => vm }
#   provisioner "local-exec" {
#     command = "az vm start --resource-group ${each.value.resourceGroupName} --name ${each.value.vmName}"
#   }
#   lifecycle {
#     ignore_changes = [triggers]
#   }
#   depends_on = [null_resource.linux_encryptionAtHost]
# }

# module "linux_guest_attestation" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesLinuxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "GuestAttestation"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Security.LinuxAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [module.linux_vm_module]
# }

# module "linux_daagent_vm_extension_module" {
#   source                     = "..\\..\\terraform-modules-hub\\terraform-modules\\vmextension"
#   for_each                   = var.sharedservicesLinuxVms
#   resource_group_name        = each.value.resourceGroupName
#   name                       = "DependencyAgentLinux"
#   virtual_machine_name       = each.value.vmName
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorLinuxAgent"
#   type_handler_version       = "1.33"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = false
#   protected_settings         = lookup(each.value, "protected_settings", null)
#   depends_on                 = [module.linux_vm_module]
#   tags                       = { "environment" : var.environment }

# }



# #------------------------------------------------------------------------------------







