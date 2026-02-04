resource "azurerm_maintenance_configuration" "update_manager" {
  name                     = var.maintenance_configuration_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  scope                    = var.scope
  visibility               = var.visibility
  in_guest_user_patch_mode = var.in_guest_user_patch_mode
  

  window {
    start_date_time      = var.maintenance_start_time
    expiration_date_time = var.maintenance_expiration_time
    duration             = var.maintenance_duration
    time_zone            = var.timezone
    recur_every          = var.recur_every
  }

  install_patches {
    linux {
      classifications_to_include    = var.linux_classifications
      package_names_mask_to_exclude = var.linux_excluded_packages
      package_names_mask_to_include = var.linux_included_packages
    }
    windows {
      classifications_to_include = var.windows_classifications
      kb_numbers_to_exclude      = var.kb_numbers_to_exclude
      kb_numbers_to_include      = var.kb_numbers_to_include
    }
    reboot = var.reboot
  }
}
