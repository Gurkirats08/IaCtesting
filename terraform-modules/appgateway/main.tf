resource "azurerm_public_ip" "appgw" {
  count               = var.sku_tier == "Standard_v2" ? 1 : 0
  name                = "ip-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
}

resource "azurerm_application_gateway" "network" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = var.gateway_ip_configuration_subnet_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port_number
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.sku_tier == "Standard_v2" ? azurerm_public_ip.appgw[0].id : null
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = var.backend_http_settings_cookie_based_affinity
    path                  = var.backend_http_settings_path
    port                  = var.backend_http_settings_port
    protocol              = var.backend_http_settings_protocol
    request_timeout       = var.backend_http_settings_request_timeout
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = var.http_listener_protocol
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = var.request_routing_rule_priority
    rule_type                  = var.request_routing_rule_type
    http_listener_name         = var.http_listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }
}
