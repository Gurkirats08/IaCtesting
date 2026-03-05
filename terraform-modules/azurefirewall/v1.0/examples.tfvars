############################
# Azure Firewall Module Usage Examples
############################

location            = "eastus"
environment         = "dev"
resource_group_name = "rg-networking-dev"

firewall_additional_tags = {
  "CostCenter" = "IT"
  "Owner"      = "NetworkTeam"
  "Purpose"    = "NetworkSecurity"
}

############################
# Firewall Policy IDs (pre-created)
############################
firewall_policy_ids = {
  "fw-hub-dev" = {
    id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-networking-dev/providers/Microsoft.Network/firewallPolicies/fwpolicy-hub-dev"
  }
}

############################
# Firewall Public IP IDs (pre-created)
############################
firewall_ip_ids = {
  "fw-hub-dev" = {
    id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-networking-dev/providers/Microsoft.Network/publicIPAddresses/pip-fw-hub-dev"
  }
}

############################
# Firewall Configuration
############################
firewalls = {
  "fw-hub-dev" = {
    firewallName        = "fw-hub-dev"
    threatIntelMode     = "Alert"
    firewallSkuName     = "AZFW_VNet"
    firewallSkuTier     = "Standard"
    vNetName            = "vnet-hub-dev"
    resourceGroupName   = "rg-networking-dev"
    subscriptionId      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    firewallIPName      = "fw-hub-dev-pip-config"
    firewallPolicyName  = "fwpolicy-hub-dev"
    firewallPolicyTier  = "Standard"
    zones               = [1, 2, 3]
  }
}

############################
# Firewall Network Rules
############################
fw_network_rules = {
  "allow-outbound-https" = {
    name         = "allow-outbound-https"
    firewall_key = "fw-hub-dev"
    priority     = 100
    action       = "Allow"
    rules = [
      {
        name                  = "https-outbound"
        description           = "Allow HTTPS outbound traffic"
        source_addresses      = ["10.0.0.0/8", "172.16.0.0/12"]
        destination_ports     = ["443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      },
      {
        name                  = "http-outbound"
        description           = "Allow HTTP outbound traffic"
        source_addresses      = ["10.0.0.0/8", "172.16.0.0/12"]
        destination_ports     = ["80"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      }
    ]
  }

  "allow-internal-traffic" = {
    name         = "allow-internal-traffic"
    firewall_key = "fw-hub-dev"
    priority     = 200
    action       = "Allow"
    rules = [
      {
        name                  = "internal-dns"
        description           = "Allow DNS traffic between internal networks"
        source_addresses      = ["10.0.0.0/8"]
        destination_ports     = ["53"]
        destination_addresses = ["10.0.0.0/8"]
        protocols             = ["TCP", "UDP"]
      }
    ]
  }

  "deny-specific-traffic" = {
    name         = "deny-specific-traffic"
    firewall_key = "fw-hub-dev"
    priority     = 1000
    action       = "Deny"
    rules = [
      {
        name                  = "deny-telnet"
        description           = "Deny Telnet traffic"
        source_addresses      = ["*"]
        destination_ports     = ["23"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      }
    ]
  }
}

############################
# Firewall NAT Rules
############################
fw_nat_rules = {
  "nat-web-servers" = {
    name         = "nat-web-servers"
    firewall_key = "fw-hub-dev"
    priority     = 100
    rules = [
      {
        name               = "nat-http"
        description        = "NAT HTTP traffic to internal web server"
        source_addresses   = ["*"]
        destination_ports  = ["80"]
        protocols          = ["TCP"]
        translated_address = "10.1.0.10"
        translated_port    = 8080
      },
      {
        name               = "nat-https"
        description        = "NAT HTTPS traffic to internal web server"
        source_addresses   = ["*"]
        destination_ports  = ["443"]
        protocols          = ["TCP"]
        translated_address = "10.1.0.10"
        translated_port    = 8443
      }
    ]
  }

  "nat-rdp-servers" = {
    name         = "nat-rdp-servers"
    firewall_key = "fw-hub-dev"
    priority     = 200
    rules = [
      {
        name               = "nat-rdp"
        description        = "NAT RDP traffic to internal management server"
        source_addresses   = ["203.0.113.0/24"]
        destination_ports  = ["3389"]
        protocols          = ["TCP"]
        translated_address = "10.1.1.50"
        translated_port    = 3389
      }
    ]
  }
}

############################
# Firewall Application Rules
############################
fw_application_rules = {
  "allow-fqdns" = {
    name         = "allow-fqdns"
    firewall_key = "fw-hub-dev"
    priority     = 100
    action       = "Allow"
    rules = [
      {
        name             = "allow-microsoft-services"
        description      = "Allow traffic to Microsoft services"
        source_addresses = ["10.0.0.0/8"]
        fqdn_tags        = ["AppServiceEnvironment", "AzureBackup", "AzureKubernetesService"]
        target_fqdns     = []
        protocol = [
          {
            port = 443
            type = "Https"
          },
          {
            port = 80
            type = "Http"
          }
        ]
      },
      {
        name             = "allow-custom-fqdns"
        description      = "Allow traffic to custom FQDNs"
        source_addresses = ["10.0.0.0/8"]
        fqdn_tags        = []
        target_fqdns     = ["api.example.com", "www.example.com", "cdn.example.com"]
        protocol = [
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ]
  }

  "allow-updates" = {
    name         = "allow-updates"
    firewall_key = "fw-hub-dev"
    priority     = 200
    action       = "Allow"
    rules = [
      {
        name             = "allow-windows-updates"
        description      = "Allow Windows Update services"
        source_addresses = ["10.0.0.0/8"]
        fqdn_tags        = ["WindowsUpdate"]
        target_fqdns     = []
        protocol = [
          {
            port = 80
            type = "Http"
          },
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ]
  }
}
