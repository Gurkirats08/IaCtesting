/*data "azurerm_client_config" "current" {}

locals {
  windows_image_ids = {
    "jstartwinvm001" = {
      source_image_reference_offer     = "WindowsServer"          # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
      source_image_reference_publisher = "MicrosoftWindowsServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
      source_image_reference_sku       = "2016-Datacenter"        # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
      source_image_reference_version   = "latest"
    }
  }
  des_exists              = { for k, v in var.windows_vms : k => v if lookup(v, "use_existing_disk_encryption_set", false) == true }
  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get", "set", "list"]
  certificate_permissions = ["get", "create", "update", "list", "import"]
  storage_permissions     = ["get"]
  subnet_nic_associations = {
    for k, v in var.windows_vm_nics : k => v if(v.subnet_name != null)
  } */

  /*
  windows_vms_for_backup = {
    for vm_k, vm_v in var.windows_vms :
    vm_k => vm_v if vm_v.recoveryServicesVaultName != null
  }
  windows_vms = {
    for vm_k, vm_v in var.windows_vms :
    vm_k => {
      zone = vm_v.availabilityZone
    }
  }
  
}*/

data "azurerm_subnet" "this" {
  for_each             = var.windows_vms
  name                 = each.value.subnetName
  virtual_network_name = each.value.vNetName
  resource_group_name  = each.value.subnetresourceGroupName
}


# -
# - Generate Password for Windows Virtual Machine
# -
resource "random_password" "this" {
  for_each         = var.windows_vms
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

/*
#
#- Availability Set
#

resource "azurerm_availability_set" "this" {
  for_each            = var.availability_sets
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]

}
*/

# -
# - Windows Virtual Machine
# -
resource "azurerm_windows_virtual_machine" "windows_vms" {
  for_each              = var.windows_vms
  name                  = lookup(each.value, "vmName", null) != null ? each.value["vmName"] : each.value["identityVMName"]
  location              = var.location
  resource_group_name   = each.value["resourceGroupName"]
  network_interface_ids = [azurerm_network_interface.windows_nics[each.key].id]
  size                  = coalesce(lookup(each.value, "vmSize"), "Standard_DS1_v2")
  encryption_at_host_enabled = true
  admin_username        = var.administrator_user_name
  #zone                  = var.zone
  admin_password        = lookup(random_password.this, each.key)["result"]
  os_disk {
    name                      = "${each.value.vmName}-${each.value.osType}"
    caching                   = coalesce(lookup(each.value, "storageOsDiskCaching"), "ReadWrite")
    storage_account_type      = coalesce(lookup(each.value, "vmDiskStorageType"), "Standard_LRS")
    disk_encryption_set_id    = var.disk_encryption_set_id
    disk_size_gb              = lookup(each.value, "diskSizeGB", null)
    write_accelerator_enabled = lookup(each.value, "writeAcceleratorEnabled", null)
  }
  identity   {
    type = var.identity_type
    identity_ids = [var.identity_ids]
  }
  enable_automatic_updates = lookup(each.value, "enableAutomaticUpdates", null)
  computer_name            = lookup(each.value, "computerName", null) != null ? upper(each.value["computerName"]) : upper(each.value["identityVMComputerName"])
  source_image_reference {
    publisher = each.value.imagePublisher
    offer     = each.value.imageOffer
    sku       = each.value.imageSku
    version   = each.value.imageVersion
  }
  lifecycle {
    ignore_changes = [
      admin_password,
      network_interface_ids,
      os_disk[0].disk_encryption_set_id
    ]
  }
  vtpm_enabled        = true
  secure_boot_enabled = true
  patch_mode          = "AutomaticByPlatform"
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  #depends_on          = [azurerm_disk_encryption_set.des]
}

# -
# - Windows Network Interfaces
# -


resource "azurerm_network_interface" "windows_nics" {
  for_each            = var.windows_vms
  name                = lookup(each.value, "vmNicSuffix", null) != null ? "${each.value.vmName}${each.value.vmNicSuffix}" : each.value.identityVMNicSuffix
  location            = var.location
  resource_group_name = each.value["resourceGroupName"]
  ip_configuration {
    name                          = each.value.ipConfigName
    subnet_id                     = data.azurerm_subnet.this[each.key].id
    private_ip_address            = lookup(each.value, "jumpBoxPrivateIP", null) != null ? each.value.jumpBoxPrivateIP : each.value.identityVMPrivateIp
    private_ip_address_allocation = each.value.privateIPAllocationMethod
  }
}


/*
resource "azurerm_virtual_machine_extension" "disable_local_auth" {
  name                 = "DisableLocalAuth"
  virtual_machine_id   = azurerm_virtual_machine.your_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
 
  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' -Name 'LocalAccountTokenFilterPolicy' -Value 0\""
    }
  SETTINGS

  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
}

# -
# - Azure Backup for an Windows Virtual Machine
# -


resource "azurerm_backup_policy_vm" "this" {
  for_each            = var.windows_vms
  name                = each.value.vm_backup_policy_name
  recovery_vault_name = each.value.recovery_services_vault_name
  resource_group_name = resource_group_name = each.value["resourceGroupName"]
  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
}


resource "azurerm_backup_protected_vm" "this" {
  for_each            = var.windows_vms
  resource_group_name = each.value["resourceGroupName"]
  recovery_vault_name = each.value["recovery_services_vault_name"]
  source_vm_id        = azurerm_windows_virtual_machine.windows_vms[each.key].id
  backup_policy_id    = lookup(resource.azurerm_backup_policy_vm.this, each.key)["id"]
  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
}


resource "azurerm_virtual_machine_extension" "gc" {
  name                       = "AzurePolicyforWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vms[each.key].id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"
  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
}

resource "azurerm_virtual_machine_extension" "daagent" {
  for_each                   = var.windows_vms
  name                       = each.value["da_extension_name"]
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vms[each.key].id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.9"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
  ]
}

*/

#########################################################
# Windows VM Managed Disk and VM & Managed Disk Attachment
#########################################################

# resource "azurerm_maintenance_configuration" "this" {
#   name                = "ksp-pcw-mg-guestpatch-mc"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   scope               = "InGuestPatch"
#   window {
#     start_date_time = "2024-01-01 00:00"
#     duration        = "03:55"
#     time_zone       = "India Standard Time"
#     recur_every     = "Day"
#   }
#   install_patches {
#     linux {
#       classifications_to_include = ["Critical", "Security"]
#     }
#     windows {
#       classifications_to_include = ["Critical", "Security"]
#     }
#     reboot = "IfRequired"
#   }
#   in_guest_user_patch_mode = "User"
# }

# resource "azurerm_maintenance_assignment_virtual_machine" "this" {
#   for_each                     = var.windows_vms
#   location                     = var.location
#   maintenance_configuration_id = azurerm_maintenance_configuration.this.id
#   virtual_machine_id           = azurerm_windows_virtual_machine.windows_vms[each.key].id
#   depends_on                   = [azurerm_maintenance_configuration.this]
# }

# -
# - Windows Network Interfaces - Internal Backend Pools Association
/*
locals {
  windows_nics_with_internal_bp_list = flatten([
    for nic_k, nic_v in var.windows_vm_nics : [
      for backend_pool_name in coalesce(nic_v["lb_backend_pool_names"], []) :
      {
        key                     = "${nic_k}_${backend_pool_name}"
        nic_key                 = nic_k
        #backend_address_pool_id = lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_backend_map_ids, backend_pool_name, null)
      }
    ]
  ])
  windows_nics_with_internal_bp = {
    for bp in local.windows_nics_with_internal_bp_list : bp.key => bp
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_nics_with_internal_backend_pools" {
  for_each                = local.windows_nics_with_internal_bp
  network_interface_id    = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).id
  ip_configuration_name   = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).ip_configuration[0].name
  backend_address_pool_id = each.value["backend_address_pool_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.windows_nics]
}
*/
#
# Windows Network Interfaces - NAT Rules Association
#
/*
locals {
  windows_nics_with_natrule_list = flatten([
    for nic_k, nic_v in var.windows_vm_nics : [
      for nat_rule_name in coalesce(nic_v["lb_nat_rule_names"], []) : [
        #for nat_rule_id in coalesce(lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_natrule_map_ids, nat_rule_name, null), []) :
        {
          #key         = "${nic_k}_${nat_rule_id}"
          nic_key     = nic_k
          #nat_rule_id = nat_rule_id
        }
      ]
    ]
  ])
  windows_nics_with_nat_rule = {
    for bp in local.windows_nics_with_natrule_list : bp.key => bp
  }
}

resource "azurerm_network_interface_nat_rule_association" "this" {
  for_each              = local.windows_nics_with_nat_rule
  network_interface_id  = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).id
  ip_configuration_name = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).ip_configuration[0].name
  nat_rule_id           = each.value["nat_rule_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.windows_nics]
}

# -
# - Windows Network Interfaces - Application Security Groups Association
# -

locals {
  windows_nics_with_asg_list = flatten([
    for nic_k, nic_v in var.windows_vm_nics : [
      for asg_name in coalesce(nic_v["app_security_group_names"], []) :
      {
        key                           = "${nic_k}_${asg_name}"
        nic_key                       = nic_k
        #application_security_group_id = lookup(data.terraform_remote_state.applicationsecuritygroup.outputs.app_security_group_ids_map, asg_name, null)
      }
    ]
  ])
  windows_nics_with_asg = {
    for asg in local.windows_nics_with_asg_list : asg.key => asg
  }
}

resource "azurerm_network_interface_application_security_group_association" "this" {
  for_each                      = local.windows_nics_with_asg
  network_interface_id          = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).id
  application_security_group_id = each.value["application_security_group_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.windows_nics]
}

# -
# - Windows Network Interfaces - Application Gateway's Backend Address Pools Association
# -

locals {
  windows_nics_with_appgw_bp_list = flatten([
    for nic_k, nic_v in var.windows_vm_nics : [
      for backend_pool_name in coalesce(nic_v["app_gateway_backend_pool_names"], []) :
      {
        key                     = "${nic_k}_${backend_pool_name}"
        #nic_key                 = nic_k
        backend_address_pool_id = lookup(data.terraform_remote_state.applicationgateway.outputs.application_gateway_backend_pool_ids_map, backend_pool_name, null)
      }
    ]
  ])
  windows_nics_with_appgw_bp = {
    for appgw in local.windows_nics_with_appgw_bp_list : appgw.key => appgw
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
  for_each                = local.windows_nics_with_appgw_bp
  network_interface_id    = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).id
  ip_configuration_name   = lookup(azurerm_network_interface.windows_nics, each.value["nic_key"]).ip_configuration[0].name
  backend_address_pool_id = each.value["backend_address_pool_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.windows_nics]
}

*/


#####################################################
# Windows VM CMK and Disk Encryption Set
#####################################################

# -
# - Generate CMK Key for Windows VM
# -
/*
resource "azurerm_key_vault_key" "this" {
  name         = var.key_vault_key
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]
}

######################################################
# Role Assignment
######################################################

# -
# - Assigning Reader Role to VM in order to access KV using MSI Identity
# -
resource "azurerm_role_assignment" "kv" {
  count                            = (var.kv_role_assignment == true && length(local.msi_enabled_windows_vms) > 0) ? length(local.vm_principal_ids) : 0
  scope                            = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  role_definition_name             = "Reader"
  principal_id                     = element(local.vm_principal_ids, count.index)
  skip_service_principal_aad_check = true
}

# -
# - Assigning Reader Role to VM in order to access itself using MSI Identity
# -
resource "azurerm_role_assignment" "vm" {
  count                            = (var.self_role_assignment == true && length(local.msi_enabled_windows_vms) > 0) ? length(local.vm_principal_ids) : 0
  scope                            = lookup(local.vm_ids_map, element(local.msi_enabled_windows_vms, count.index)["name"])
  role_definition_name             = "Reader"
  principal_id                     = element(local.vm_principal_ids, count.index)
  skip_service_principal_aad_check = true
}

*/
# data "azurerm_key_vault" "this" {
#   name = var.key_vault_name
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_subnet" "this" {
#   for_each             = local.subnet_nic_associations
#   name                 = each.value.subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name = var.networking_resource_group
# }

# -
# - Store Generated Password to Key Vault Secrets
# -


# resource "azurerm_key_vault_secret" "this" {
#   for_each     = var.windows_vms
#   name         = each.value["name"]
#   value        = lookup(random_password.this, each.key)["result"]
#   key_vault_id = data.azurerm_key_vault.this.id

#   lifecycle {
#     ignore_changes = [value]
#   }
# }
