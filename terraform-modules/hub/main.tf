locals {
  prefix-hub         = var.prefix-hub
  hub-location       = var.hub-location
  hub-resource-group = var.hub-resource-group
}
module "resource_group" {
  source              = "../resource_group"
  enabled             = var.deploy_hub_resource_group
  resource_group_name = local.hub-resource-group
  location            = local.hub-location
}
resource "azurerm_virtual_wan" "vwan" {
  count               = var.enabled && var.deploy_hub_resource_group ? 1 : 0
  name                = "vwan-${var.hub-location}"
  resource_group_name = module.resource_group.resource_group_name[count.index]
  location            = var.hub-location
  depends_on          = [module.resource_group]
}
resource "azurerm_virtual_hub" "azurerm_virtual_hub" {
  count               = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets ? 1 : 0
  name                = "${local.prefix-hub}-${var.hub-location}"
  resource_group_name = module.resource_group.resource_group_name[count.index]
  location            = var.hub-location
  virtual_wan_id      = azurerm_virtual_wan.vwan[count.index].id
  address_prefix      = var.address_prefix_hub
  depends_on          = [module.resource_group, azurerm_virtual_wan.vwan, module.virtual_networks]
}
# module "vnets" {
#   source                = "../hub_vnets"
#   enabled               = var.deploy_hub_vnets
#   deploy_resource_group = var.deploy_hub_resource_group
#   resource_group_name   = module.resource_group.resource_group_name
#   resource_group_id     = module.resource_group.resource_group_id
#   virtual_network_name  = "${local.prefix-hub}-vnet"
#   location              = var.hub-location
#   address_space         = var.address_prefix_hubvnet

#   depends_on = [module.resource_group]
# }
module "virtual_networks" {
  source                = "../virtual_networks"
  count                 = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets ? 1 : 0
  enabled               = var.deploy_hub_vnets
  deploy_resource_group = var.deploy_hub_resource_group
  resource_group_name   = module.resource_group.resource_group_name[count.index]
  virtual_networks_list = ["${local.prefix-hub}-vnet"]
  virtual_networks = {
    "${local.prefix-hub}-vnet" = {
      name          = "${local.prefix-hub}-vnet"
      address_space = [var.address_prefix_hubvnet]
    }
  }
  depends_on = [
    module.resource_group
  ]
}

#Connection of Vnet to a Hub
resource "azurerm_virtual_hub_connection" "vHubConnection" {
  count                     = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets ? 1 : 0
  name                      = "example-connection"
  virtual_hub_id            = azurerm_virtual_hub.azurerm_virtual_hub[count.index].id
  remote_virtual_network_id = module.virtual_networks[count.index].virtual_network_id

  depends_on = [module.virtual_networks, azurerm_virtual_hub.azurerm_virtual_hub]
}

#VPN gateway
# module "subnets" {
#   source = "../hub_subnets"

#   enabled                = var.deploy_hub_subnets
#   deploy_resource_group  = var.deploy_hub_resource_group
#   deploy_virtual_network = var.deploy_hub_vnets
#   resource_group_name    = module.resource_group.resource_group_name
#   resource_group_id      = module.resource_group.resource_group_id
#   virtual_network_name   = module.vnets.virtual_network_name
#   virtual_network_id     = module.vnets.virtual_network_id
#   subnet_name            = "GatewaySubnet"
#   address_prefix         = ["20.0.1.0/24"]

#   depends_on = [
#     module.resource_group,
#     module.vnets
#   ]
# }
resource "azurerm_subnet" "GatewaySubnet" {
  count                = (var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets) ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = module.resource_group.resource_group_name[count.index]
  virtual_network_name = module.virtual_networks[count.index].virtual_network_name
  address_prefixes     = ["20.0.1.0/24"]
}
resource "azurerm_vpn_gateway" "VpnGateway" {
  count               = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets ? 1 : 0
  name                = "VPN-Gateway"
  location            = var.hub-location
  resource_group_name = module.resource_group.resource_group_name[count.index]
  virtual_hub_id      = azurerm_virtual_hub.azurerm_virtual_hub[count.index].id

  depends_on = [azurerm_virtual_hub.azurerm_virtual_hub, module.resource_group]
}

#Firewall
# module "subnet_firewall" {
#   source = "../hub_subnets"

#   enabled                = true
#   deploy_resource_group  = var.deploy_hub_resource_group
#   deploy_virtual_network = var.deploy_hub_vnets
#   resource_group_name    = module.resource_group.resource_group_name
#   resource_group_id      = module.resource_group.resource_group_id
#   virtual_network_name   = module.vnets.virtual_network_name
#   virtual_network_id     = module.vnets.virtual_network_id
#   subnet_name            = "AzureFirewallSubnet"
#   address_prefix         = ["20.0.2.0/24"]

#   depends_on = [
#     module.resource_group,
#     module.vnets
#   ]
# }
resource "azurerm_subnet" "FirewallSubnet" {
  count                = (var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets) ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.resource_group_name[count.index]
  virtual_network_name = module.virtual_networks[count.index].virtual_network_name
  address_prefixes     = ["20.0.2.0/24"]
}

# resource "azurerm_public_ip" "public_ip" {
#   count               = var.enabled ? 1 : 0
#   name                = "Public_IP"
#   location            = var.hub-location
#   resource_group_name = module.resource_group.resource_group_name[count.index]
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

module "public_ip" {
  source                = "../public_ip"
  count                 = var.enabled && var.deploy_hub_resource_group ? 1 : 0
  enabled               = true
  deploy_resource_group = var.deploy_hub_resource_group
  public_ip_name        = "Firewall_IP"
  location              = var.hub-location
  resource_group_id     = module.resource_group.resource_group_id[count.index]
  resource_group_name   = module.resource_group.resource_group_name[count.index]

  depends_on = [
    module.resource_group
  ]
}

resource "azurerm_firewall" "firewall" {
  count               = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets ? 1 : 0
  name                = "${local.prefix-hub}-Firewall"
  resource_group_name = module.resource_group.resource_group_name[count.index]
  location            = var.hub-location
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "AzureFirewallSubnet"
    subnet_id            = azurerm_subnet.FirewallSubnet[count.index].id
    public_ip_address_id = module.public_ip[0].public_ip_id
  }
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.azurerm_virtual_hub[count.index].id
  }
  depends_on = [azurerm_virtual_hub.azurerm_virtual_hub, module.public_ip, module.resource_group, azurerm_subnet.FirewallSubnet]
}

resource "azurerm_vpn_server_configuration" "example" {
  count                    = var.enabled && var.deploy_hub_resource_group ? 1 : 0
  name                     = "example-config"
  resource_group_name      = module.resource_group.resource_group_name[count.index]
  location                 = var.hub-location
  vpn_authentication_types = ["Certificate"]

  client_root_certificate {
    name             = "DigiCert-Federated-ID-Root-CA"
    public_cert_data = <<EOF
MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
EOF
  }
}

resource "azurerm_point_to_site_vpn_gateway" "example" {
  count                       = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets ? 1 : 0
  name                        = "example-vpn-gateway"
  location                    = var.hub-location
  resource_group_name         = module.resource_group.resource_group_name[count.index]
  virtual_hub_id              = azurerm_virtual_hub.azurerm_virtual_hub[count.index].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.example[count.index].id
  scale_unit                  = 1
  connection_configuration {
    name = "example-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [
        "10.0.2.0/24"
      ]
    }
  }
  depends_on = [azurerm_vpn_server_configuration.example, azurerm_virtual_hub.azurerm_virtual_hub, module.resource_group]
}

#ExpressRoute Gateway
resource "azurerm_express_route_gateway" "example" {
  count               = var.enabled && var.deploy_hub_resource_group && var.deploy_hub_vnets && var.deploy_hub_subnets ? 1 : 0
  name                = "expressRoute1"
  resource_group_name = module.resource_group.resource_group_name[count.index]
  location            = var.hub-location
  virtual_hub_id      = azurerm_virtual_hub.azurerm_virtual_hub[count.index].id
  scale_units         = 1

  tags = {
    environment = "Production"
  }
  depends_on = [azurerm_virtual_hub.azurerm_virtual_hub, module.resource_group]
}


# #VPN Gateway POINT to SITE
# resource "azurerm_vpn_server_configuration" "example" {
#   name                     = "example-config"
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   vpn_authentication_types = ["Certificate"]

#   client_root_certificate {
#     name             = "DigiCert-Federated-ID-Root-CA"
#     public_cert_data = <<EOF
#       MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
#       MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
#       d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
#       Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
#       BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
#       Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
#       MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
#       QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
#       zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
#       GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
#       GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
#       Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
#       DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
#       HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
#       jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
#       9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
#       QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
#       uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
#       WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
#       M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
#       EOF
#   }
# }

# resource "azurerm_point_to_site_vpn_gateway" "example" {
#   name                        = "example-vpn-gateway"
#   location                    = azurerm_resource_group.example.location
#   resource_group_name         = azurerm_resource_group.example.name
#   virtual_hub_id              = azurerm_virtual_hub.example.id
#   vpn_server_configuration_id = azurerm_vpn_server_configuration.example.id
#   scale_unit                  = 1

#   connection_configuration {
#     name = "example-gateway-config"
#     vpn_client_address_pool {
#       address_prefixes = ["10.0.2.0/24"]
#     }
#   }
# }

# # resource "azurerm_resource_group" "example" {
# #   name     = "example-resources"
# #   location = "West Europe"
# # }


# resource "azurerm_public_ip" "example" {
#   name                = "example-pip"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_virtual_network_gateway" "example" {
#   name                = "example-gateway"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   type     = "ExpressRoute"
#   vpn_type = "RouteBased"

#   sku                        = "Standard"
#   enable_bgp                 = false
#   generation                 = "Generation1"
#   active_active              = false
#   private_ip_address_enabled = false

#   ip_configuration {
#     name                          = "vnetGatewayConfig"
#     public_ip_address_id          = azurerm_public_ip.example.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.example.id
#   }
# }
