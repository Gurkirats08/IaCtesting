resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = merge(local.tags, var.tags)

  dynamic "soa_record" {
    for_each = var.soa_email != null ? [1] : []
    content {
      email = var.soa_email
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
