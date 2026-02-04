variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group" {
  description = "Resource group for the VM and disks"
  type        = string
}

variable "lun" {
  description = "Logical unit number for the disk"
  type        = number
}

variable "caching" {
  description = "Disk caching mode (None, ReadOnly, or ReadWrite)"
  type        = string
}

variable "data_disk_name" {
  description = "ID of the managed data disk"
  type        = string

}
