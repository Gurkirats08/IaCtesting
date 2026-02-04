// generating a random password
resource "random_password" "this" {
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_mssql_server" "sql" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = random_password.this.result
  tags                          = var.tags
  public_network_access_enabled = false

}

resource "azurerm_mssql_database" "db" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.sql.id
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  zone_redundant = var.zone_redundant
  tags           = var.tags
  threat_detection_policy {
    state                = "Enabled"
    email_account_admins = "Enabled"
    email_addresses      = var.email_addresses
  }
}

resource "azurerm_mssql_server_security_alert_policy" "policy_alert" {
  resource_group_name  = var.resource_group_name
  server_name          = azurerm_mssql_server.sql.name
  state                = "Enabled"
  email_account_admins = true
  email_addresses      = var.email_addresses
  retention_days       = 7
}

#Enabling auditing on the SQL Server and Database
resource "azurerm_mssql_server_extended_auditing_policy" "sql_auditing" {
  server_id              = azurerm_mssql_server.sql.id
  enabled                = true
  log_monitoring_enabled = true
}

resource "azurerm_mssql_database_extended_auditing_policy" "database_auditing" {
  database_id            = azurerm_mssql_database.db.id
  enabled                = true
  log_monitoring_enabled = true
}


#Enabling vulnerability assessment on the SQL Server and Database
# data "azurerm_storage_account" "stg" {
#   name                = var.storage_account_name
#   resource_group_name = var.storage_account_rg
# }

# data "azurerm_storage_container" "container" {
#   name                  = var.container_name
#   storage_account_name  = data.azurerm_storage_account.stg.name
# }


# #Enabling vulnerability assessment on the SQL Server and Database
# resource "azurerm_mssql_server_vulnerability_assessment" "sql_vulnerability" {
#   server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.policy_alert.id
#   storage_container_path = "https://${data.azurerm_storage_account.stg.primary_blob_endpoint}${data.azurerm_storage_container.container.name}"
#   recurring_scans {
#     enabled                   = true
#     email_subscription_admins = true
#     emails = [
#       "email@example1.com",
#     ]
#   }
# }