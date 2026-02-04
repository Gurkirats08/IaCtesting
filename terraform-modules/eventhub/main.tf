resource "azurerm_eventhub" "this" {
  name                = var.eventhub_name
  resource_group_name = var.resource_group_name
  namespace_name      = var.eventhub_namespace_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
  status              = var.status

  dynamic "capture_description" {
    for_each = {
      for key, value in var.capture_description : key => value
      if(try(value.destination, null) != null && try(var.capture_description, {}) != {})
    }
    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = lookup(capture_description.value, "interval_in_seconds", null)
      size_limit_in_bytes = lookup(capture_description.value, "size_limit_in_bytes", null)
      skip_empty_archives = lookup(capture_description.value, "skip_empty_archives", null)
      dynamic "destination" {
        for_each = try(capture_description.value.destination, null) != null ? [capture_description.value.destination] : []
        content {
          name                = destination.value.name
          archive_name_format = destination.value.archive_name_format
          blob_container_name = destination.value.blob_container_name
          storage_account_id  = destination.value.storage_account_id
        }
      }
    }
  }
}

resource "azurerm_eventhub_authorization_rule" "this" {
  count               = var.enable_authorization == true ? 1 : 0
  name                = format("%s-key", azurerm_eventhub.this.name)
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
  listen              = var.listen
  send                = var.send
  manage              = var.manage
}

#AEH_IAM_007
resource "azurerm_eventhub_consumer_group" "this" {
  name                = var.eventhub_consumer_group_name
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
}
