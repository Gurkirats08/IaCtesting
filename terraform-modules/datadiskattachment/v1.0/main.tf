# Data block to fetch the VM details
data "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group
}

data "azurerm_managed_disk" "existing" {
  name                = var.data_disk_name
  resource_group_name = var.resource_group
}

# Attach the disk to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  managed_disk_id    = data.azurerm_managed_disk.existing.id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = var.lun
  caching            = var.caching
}