# Azure Firewall Module - Usage Examples

This document provides comprehensive examples of how to use the Azure Firewall module with firewall rules.

## Basic Module Usage

### Step 1: Reference the Module

```hcl
module "azure_firewall" {
  source = "../../terraform-modules/azurefirewall/v1.0"

  location            = var.location
  environment         = var.environment
  resource_group_name = azurerm_resource_group.networking.name

  firewalls           = var.firewalls
  firewall_policy_ids = module.firewall_policy.firewall_policy_ids
  firewall_ip_ids     = module.public_ip.public_ip_ids
  
  fw_network_rules      = var.fw_network_rules
  fw_nat_rules          = var.fw_nat_rules
  fw_application_rules  = var.fw_application_rules

  firewall_additional_tags = local.common_tags
}
```

### Step 2: Define Variables in Terraform Files

#### Firewall Configuration Example

```hcl
variable "firewalls" {
  type = map(object({
    firewallName               = string
    threatIntelMode            = string
    firewallSkuName            = string
    firewallSkuTier            = string
    vNetName                   = string
    resourceGroupName          = string
    subscriptionId             = optional(string)
    firewallIPName             = string
    firewallIpAllocationMethod = string
    firewallPolicyName         = string
    firewallPolicyTier         = string
    zones                      = optional(list(number))
  }))
  default = {}
}
```

**Example tfvars values:**

```hcl
firewalls = {
  "fw-hub-prod" = {
    firewallName        = "fw-hub-prod"
    threatIntelMode     = "Alert"
    firewallSkuName     = "AZFW_VNet"
    firewallSkuTier     = "Standard"
    vNetName            = "vnet-hub-prod"
    resourceGroupName   = "rg-networking-prod"
    subscriptionId      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    firewallIPName      = "fw-hub-prod-pip-config"
    firewallPolicyName  = "fwpolicy-hub-prod"
    firewallPolicyTier  = "Standard"
    zones               = [1, 2, 3]
  }
}
```

## Network Rules Examples

### Allow Outbound HTTPS Traffic

```hcl
fw_network_rules = {
  "allow-outbound-https" = {
    name         = "allow-outbound-https"
    firewall_key = "fw-hub-prod"
    priority     = 100
    action       = "Allow"
    rules = [
      {
        name                  = "https-outbound"
        description           = "Allow HTTPS outbound traffic"
        source_addresses      = ["10.0.0.0/8"]
        destination_ports     = ["443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      }
    ]
  }
}
```

### Allow Internal DNS Traffic

```hcl
fw_network_rules = {
  "allow-internal-dns" = {
    name         = "allow-internal-dns"
    firewall_key = "fw-hub-prod"
    priority     = 200
    action       = "Allow"
    rules = [
      {
        name                  = "internal-dns"
        description           = "Allow DNS between subnets"
        source_addresses      = ["10.0.0.0/8"]
        destination_ports     = ["53"]
        destination_addresses = ["10.253.0.1"]  # Internal DNS server IP
        protocols             = ["TCP", "UDP"]
      }
    ]
  }
}
```

### Deny Specific Traffic

```hcl
fw_network_rules = {
  "deny-telnet" = {
    name         = "deny-telnet"
    firewall_key = "fw-hub-prod"
    priority     = 1000
    action       = "Deny"
    rules = [
      {
        name                  = "block-telnet"
        description           = "Block Telnet (insecure)"
        source_addresses      = ["*"]
        destination_ports     = ["23"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      }
    ]
  }
}
```

## NAT Rules Examples

### HTTP/HTTPS Port Translation

```hcl
fw_nat_rules = {
  "nat-web-app" = {
    name         = "nat-web-app"
    firewall_key = "fw-hub-prod"
    priority     = 100
    rules = [
      {
        name               = "nat-http"
        description        = "NAT external HTTP to internal web server"
        source_addresses   = ["*"]
        destination_ports  = ["80"]
        protocols          = ["TCP"]
        translated_address = "10.1.0.10"
        translated_port    = 8080
      },
      {
        name               = "nat-https"
        description        = "NAT external HTTPS to internal web server"
        source_addresses   = ["*"]
        destination_ports  = ["443"]
        protocols          = ["TCP"]
        translated_address = "10.1.0.10"
        translated_port    = 8443
      }
    ]
  }
}
```

### RDP Access from Specific Subnet

```hcl
fw_nat_rules = {
  "nat-rdp-mgmt" = {
    name         = "nat-rdp-mgmt"
    firewall_key = "fw-hub-prod"
    priority     = 200
    rules = [
      {
        name               = "rdp-from-admin-subnet"
        description        = "Allow RDP from admin subnet to internal servers"
        source_addresses   = ["203.0.113.0/24"]  # Admin network
        destination_ports  = ["3389"]
        protocols          = ["TCP"]
        translated_address = "10.1.1.50"
        translated_port    = 3389
      }
    ]
  }
}
```

## Application Rules Examples

### Allow Microsoft Services (Using FQDN Tags)

```hcl
fw_application_rules = {
  "allow-azure-services" = {
    name         = "allow-azure-services"
    firewall_key = "fw-hub-prod"
    priority     = 100
    action       = "Allow"
    rules = [
      {
        name             = "azure-platform-services"
        description      = "Allow traffic to Azure platform services"
        source_addresses = ["10.0.0.0/8"]
        fqdn_tags        = ["AppServiceEnvironment", "AzureBackup", "AzureKubernetesService"]
        target_fqdns     = []
        protocol = [
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ]
  }
}
```

### Allow Custom FQDNs

```hcl
fw_application_rules = {
  "allow-custom-domains" = {
    name         = "allow-custom-domains"
    firewall_key = "fw-hub-prod"
    priority     = 200
    action       = "Allow"
    rules = [
      {
        name             = "company-services"
        description      = "Allow traffic to company services"
        source_addresses = ["10.0.0.0/8"]
        fqdn_tags        = []
        target_fqdns     = ["api.company.com", "portal.company.com", "data.company.com"]
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
      }
    ]
  }
}
```

### Allow Windows Updates

```hcl
fw_application_rules = {
  "allow-windows-updates" = {
    name         = "allow-windows-updates"
    firewall_key = "fw-hub-prod"
    priority     = 300
    action       = "Allow"
    rules = [
      {
        name             = "windows-update"
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
```

## Complete Module Call Example

```hcl
# Local variables for common configuration
locals {
  location = "eastus"
  environment = "prod"
}

# Pre-requisite: Create firewall policy
resource "azurerm_firewall_policy" "hub" {
  name                = "fwpolicy-hub-prod"
  location            = local.location
  resource_group_name = azurerm_resource_group.networking.name
  sku                 = "Standard"
}

# Pre-requisite: Create public IP for firewall
resource "azurerm_public_ip" "firewall" {
  name                = "pip-fw-hub-prod"
  location            = local.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Deploy Azure Firewall with Rules
module "azure_firewall" {
  source = "../../terraform-modules/azurefirewall/v1.0"

  location            = local.location
  environment         = "prod"
  resource_group_name = azurerm_resource_group.networking.name

  # Firewall configuration
  firewalls = {
    "fw-hub-prod" = {
      firewallName        = "fw-hub-prod"
      threatIntelMode     = "Alert"
      firewallSkuName     = "AZFW_VNet"
      firewallSkuTier     = "Standard"
      vNetName            = azurerm_virtual_network.hub.name
      resourceGroupName   = azurerm_resource_group.networking.name
      subscriptionId      = data.azurerm_client_config.current.subscription_id
      firewallIPName      = "fw-hub-prod-pip-config"
      firewallPolicyName  = azurerm_firewall_policy.hub.name
      firewallPolicyTier  = "Standard"
      zones               = [1, 2, 3]
    }
  }

  # Reference to pre-created resources
  firewall_policy_ids = {
    "fw-hub-prod" = {
      id = azurerm_firewall_policy.hub.id
    }
  }

  firewall_ip_ids = {
    "fw-hub-prod" = {
      id = azurerm_public_ip.firewall.id
    }
  }

  # Network Rules
  fw_network_rules = {
    "allow-outbound" = {
      name         = "allow-outbound"
      firewall_key = "fw-hub-prod"
      priority     = 100
      action       = "Allow"
      rules = [
        {
          name                  = "https-outbound"
          description           = "Allow HTTPS outbound"
          source_addresses      = ["10.0.0.0/8"]
          destination_ports     = ["443"]
          destination_addresses = ["*"]
          protocols             = ["TCP"]
        }
      ]
    }
  }

  # NAT Rules
  fw_nat_rules = {
    "nat-web" = {
      name         = "nat-web"
      firewall_key = "fw-hub-prod"
      priority     = 100
      rules = [
        {
          name               = "nat-http"
          description        = "NAT HTTP"
          source_addresses   = ["*"]
          destination_ports  = ["80"]
          protocols          = ["TCP"]
          translated_address = "10.1.0.10"
          translated_port    = 8080
        }
      ]
    }
  }

  # Application Rules
  fw_application_rules = {
    "allow-azure" = {
      name         = "allow-azure"
      firewall_key = "fw-hub-prod"
      priority     = 100
      action       = "Allow"
      rules = [
        {
          name             = "azure-services"
          description      = "Allow Azure services"
          source_addresses = ["10.0.0.0/8"]
          fqdn_tags        = ["AzureBackup"]
          target_fqdns     = []
          protocol = [
            {
              port = 443
              type = "Https"
            }
          ]
        }
      ]
    }
  }

  firewall_additional_tags = {
    "CostCenter" = "IT"
    "Owner"      = "NetworkTeam"
  }
}

# Use module outputs
output "firewall_private_ips" {
  value = module.azure_firewall.firewall_ips_map
}

output "rule_collection_ids" {
  value = {
    network_rules      = module.azure_firewall.network_rule_collection_ids
    nat_rules          = module.azure_firewall.nat_rule_collection_ids
    application_rules  = module.azure_firewall.application_rule_collection_ids
  }
}
```

## Key Points

1. **Pre-requisites**: Ensure firewall policies and public IPs are created before calling the module
2. **Priority Order**: Network rules are processed in priority order (lower number = higher priority)
3. **Actions**: 
   - Network Rules: "Allow" or "Deny"
   - NAT Rules: Always "Dnat" (handled by module)
   - Application Rules: "Allow" or "Deny"
4. **FQDN Tags**: Use predefined tags for common services (WindowsUpdate, AzureBackup, etc.)
5. **Source/Destination**: Use CIDR notation for IP ranges or "*" for any address

## Available FQDN Tags

Common FQDN tags include:
- `WindowsUpdate`
- `AppServiceEnvironment`
- `AzureBackup`
- `AzureKubernetesService`
- `MicrosoftActiveProtectionService`
- `Office365`

See [Azure Firewall FQDN Tags documentation](https://learn.microsoft.com/en-us/azure/firewall/fqdn-tags) for complete list.
