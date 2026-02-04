locals {
  resourcegroup_state_exists = false
}

data "azurerm_subnet" "this" {
  for_each             = var.linux_vms
  name                 = each.value.subnetName
  virtual_network_name = each.value.vNetName
  resource_group_name  = each.value.subnetresourceGroupName
}

# - Generate Password for Linux Virtual Machine
resource "random_password" "this" {
  for_each         = var.linux_vms
  length           = 12
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}


# - Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vms" {
  for_each                        = var.linux_vms
  name                            = lookup(each.value, "vmName", null) != null ? each.value["vmName"] : each.value["connVMName"]
  location                        = var.location
  resource_group_name             = each.value["resourceGroupName"]
  zone                            = lookup(each.value, "zone", null)
  network_interface_ids           = [azurerm_network_interface.linux_nics[each.key].id]
  size                            = coalesce(lookup(each.value, "vmSize"), "Standard_DS1_v2")
  encryption_at_host_enabled      = true
  disable_password_authentication = false
  admin_username                  = var.administrator_user_name
  admin_password                  = lookup(random_password.this, each.key)["result"]

  os_disk {
    name                      = "${each.value.vmName}-${each.value.osType}"
    caching                   = coalesce(lookup(each.value, "storageOsDiskCaching"), "ReadWrite")
    storage_account_type      = coalesce(lookup(each.value, "vmDiskStorageType"), "Standard_LRS")
    disk_size_gb              = lookup(each.value, "diskSizeGB", null)
    disk_encryption_set_id    = var.disk_encryption_set_id
    write_accelerator_enabled = lookup(each.value, "writeAcceleratorEnabled", null)
  }
  identity {
    type         = var.identity_type
    identity_ids = [var.identity_ids]
  }

  source_image_reference {
    publisher = each.value.imagePublisher
    offer     = each.value.imageOffer
    sku       = each.value.imageSku
    version   = each.value.imageVersion
  }


  lifecycle {
    ignore_changes = [
      admin_password,
      network_interface_ids
    ]
  }

}


resource "azurerm_network_interface" "linux_nics" {
  for_each            = var.linux_vms
  name                = lookup(each.value, "vmNicSuffix", null) != null ? "${each.value.vmName}${each.value.vmNicSuffix}" : each.value.ConnlinuxNicSuffix
  location            = var.location
  resource_group_name = each.value["resourceGroupName"]

  dynamic "ip_configuration" {
    for_each = length(each.value) > 0 && contains(keys(each.value), "jumpBoxPrivateIP") ? [each.value] : [null]
    content {
      name                          = lookup(each.value, "ipConfigName", "default-ipconfig")
      subnet_id                     = data.azurerm_subnet.this[each.key].id
      private_ip_address            = lookup(each.value, "jumpBoxPrivateIP", null) != null ? each.value.jumpBoxPrivateIP : each.value.ConnlinuxVMPrivateIp
      private_ip_address_allocation = lookup(each.value, "privateIPAllocationMethod", "Dynamic") # Fallback to Dynamic allocation
      primary                       = var.primary
    }
  }
}


# resource "azurerm_virtual_machine_extension" "vm_extension" {
#   name                 = "${azurerm_linux_virtual_machine.linux_vms.name}-cse"
#   virtual_machine_id   = azurerm_linux_virtual_machine.linux_vms[each.key].id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     ${jsonencode(var.cse_settings_object)}
#     SETTINGS

#   lifecycle {
#     ignore_changes = [
#       settings
#     ]
#   }

#   depends_on = [resource.azurerm_linux_virtual_machine.linux_vms]
# }

# resource "azurerm_virtual_machine_extension" "gc_extension" {
#   name                       = "AzurePolicyforLinux"
#   virtual_machine_id         = 
#   publisher                  = "Microsoft.GuestConfiguration"
#   type                       = "ConfigurationForLinux"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = "true"
#   depends_on                 = [resource.azurerm_linux_virtual_machine.linux_vms]
# }

# resource "azurerm_virtual_machine_extension" "guest_attestation" {
#   for_each                   = var.linux_vms
#   name                       = "GuestAttestation-${each.key}"
#   virtual_machine_id         = azurerm_linux_virtual_machine.linux_vms[each.key].id
#   publisher                  = "Microsoft.Azure.Security.WindowsAttestation"
#   type                       = "GuestAttestation"
#   type_handler_version       = "1.0"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   depends_on                 = [azurerm_linux_virtual_machine.linux_vms]
# }
