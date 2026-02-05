# Azure Landing Zone Deployment (IaC Testing)

Complete Infrastructure-as-Code (IaC) solution for deploying Azure Landing Zone (ALZ) across multiple subscription platforms using Terraform and GitHub Actions.

## 📁 Repository Structure

```
IaCtesting/
├── .github/
│   └── workflows/                          # GitHub Actions workflows (required location)
│       ├── alz-deployment.yml              # Connectivity platform workflow
│       ├── alz-identity.yml                # Identity platform workflow
│       ├── alz-management.yml              # Management platform workflow
│       ├── alz-security.yml                # Security platform workflow
│       └── alz-sharedservices.yml          # Shared Services platform workflow
│
├── terraform-modules/                      # Reusable Terraform modules (HUB)
│   ├── AKS/
│   ├── AKS-Nodepool/
│   ├── AKSBackupPolicy/
│   ├── apimanagement/
│   ├── appgateway/
│   ├── applicationinsights/
│   ├── automationAccount/
│   ├── AzureContainerRegistry/
│   ├── azurefirewall/
│   ├── azurepolicy/
│   ├── backupvault/
│   ├── bastionhost/
│   ├── cognitivesearch/
│   ├── cosmodbaccount/
│   ├── cosmodbsqldatabase/
│   ├── cosmosdb/
│   ├── cosmosdbsqlcontainer/
│   ├── customalerts/
│   ├── databricksworkspace/
│   ├── datacollectionendpoint/
│   ├── datacollectionrule/
│   ├── datadisk/
│   ├── datadiskattachment/
│   ├── datafactory/
│   ├── ddos/
│   ├── diagnosticlogs/
│   ├── diskbackuppolicy/
│   ├── diskencryptionset/
│   ├── eventhub/
│   ├── eventhubnamespace/
│   ├── firewallPolicy/
│   ├── hub/
│   ├── keyvault/
│   ├── keyvaultkey/
│   ├── linuxvm/
│   ├── localnetworkgateway/
│   ├── loganalytics/
│   ├── machinelearning/
│   ├── managementgroup/
│   ├── mssqlserver/
│   ├── mysqlFlexibleDatabase/
│   ├── mysqlFlexibleServer/
│   ├── networksecuritygroup/
│   ├── networkwatcher/
│   ├── nsgflowlogs/
│   ├── openai/
│   ├── peering/
│   ├── postgresqlDatabase/
│   ├── postgresqlFlexible/
│   ├── privatedns-a-record/
│   ├── privatednszone/
│   ├── privatednszonevirtualnetworklink/
│   ├── privateendpoint/
│   ├── publicip/
│   ├── rbac/
│   ├── recoveryservicevault/
│   ├── rediscache/
│   ├── resourcegroup/
│   ├── resourcelock/
│   ├── routetable/
│   ├── sentinel/
│   ├── serviceplan/
│   ├── sqlpaas/
│   ├── storageaccount/
│   ├── storagebackuppolicy/
│   ├── subnet/
│   ├── subscription/
│   ├── synapseworkspace/
│   ├── updatemanager/
│   ├── userassignedidentity/
│   ├── virtualnetwork/
│   ├── vmbackuppolicy/
│   ├── vmextension/
│   ├── vnetgateway/
│   ├── vnetpeering/
│   ├── vpnconnections/
│   ├── vpnpublicip/
│   ├── windowsvm/
│   └── windowswebapp/
│
├── platform-connectivity-alz-deployment/   # Connectivity subscription
│   ├── platform-deployment/                # Deployment documentation & references
│   │   └── README.md                       # Connectivity deployment guide
│   ├── connectivity/                       # Terraform code
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tfvars
│   │   └── connectivity.tfvars
│   └── README.md
│
├── platform-identity-alz-deployment/       # Identity subscription
│   ├── platform-deployment/                # Deployment documentation & references
│   │   └── README.md                       # Identity deployment guide
│   ├── identity_dev/                       # Terraform code
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tfvars
│   │   └── identity.tfvars
│   └── README.md
│
├── platform-management-alz-deployment/     # Management subscription
│   ├── platform-deployment/                # Deployment documentation & references
│   │   └── README.md                       # Management deployment guide
│   ├── management/                         # Terraform code
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tfvars
│   │   └── management.tfvars
│   └── README.md
│
├── platform-security-alz-deployment/       # Security subscription
│   ├── platform-deployment/                # Deployment documentation & references
│   │   └── README.md                       # Security deployment guide
│   ├── security/                           # Terraform code
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tfvars
│   │   └── security.tfvars
│   └── README.md
│
├── platform-sharedservices-alz-deployment/ # Shared Services subscription
│   ├── platform-deployment/                # Deployment documentation & references
│   │   └── README.md                       # Shared Services deployment guide
│   ├── sharedservices/                     # Terraform code
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tfvars
│   │   └── sharedservices.tfvars
│   └── README.md
│
├── GITHUB_ACTIONS_SETUP.md                 # GitHub Actions setup guide
└── README.md                               # This file
```

## 🏗️ Architecture Overview

### Terraform Modules (Hub)
The `terraform-modules/` directory contains reusable, versioned Terraform modules for all Azure resources. Each module is self-contained and can be used independently.

**Key Features:**
- Modular design for reusability
- Consistent naming conventions
- Built-in tags and naming
- Comprehensive variable validation
- Output references for resource dependencies

### Platform Subscriptions
Each platform represents a separate Azure subscription with its own Terraform state management.

| Platform | Folder | Workflow | Storage Account | Container | Purpose |
|---|---|---|---|---|---|
| **Connectivity** | `platform-connectivity-alz-deployment/` | `alz-deployment.yml` | `stphiconndevopseus033` | `connectivity-state` | Network connectivity & hub infrastructure |
| **Identity** | `platform-identity-alz-deployment/` | `alz-identity.yml` | `stphiidntdevopstest3131` | `identity-state` | Identity & access management |
| **Management** | `platform-management-alz-deployment/` | `alz-management.yml` | `stmgmtdevopssea020` | `management-state` | Management, monitoring & compliance |
| **Security** | `platform-security-alz-deployment/` | `alz-security.yml` | `stphisecdevopssea020` | `security-state` | Security & compliance resources |
| **Shared Services** | `platform-sharedservices-alz-deployment/` | `alz-sharedservices.yml` | `philiactestingsea01` | `iacstate` | Shared services & common resources |

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.6.0
- Azure CLI authenticated
- GitHub account with repository access
- Azure subscription(s) with appropriate permissions
- Service Principal or Managed Identity configured

### 1. Setup GitHub Actions
Follow the [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) guide to:
- Configure OIDC authentication
- Add repository secrets
- Setup environment approvals

### 2. Deploy a Platform

#### Via GitHub Actions (Recommended)
```bash
# Go to GitHub
1. Navigate to Actions
2. Select the platform workflow (e.g., ALZ Management Deployment)
3. Click "Run workflow"
4. Select Environment and Action (plan/apply/destroy)
5. Review and approve
```

#### Via Terraform CLI (Local)
```bash
# Example: Deploy Management platform
cd platform-management-alz-deployment/management

# Initialize backend
terraform init -backend-config="backend.tfvars"

# Plan deployment
terraform plan -var-file="management.tfvars" -out=tfplan

# Apply deployment
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="management.tfvars"
```

## 📋 Platform Deployment Guides

Each platform has detailed deployment documentation:

- **Connectivity**: [platform-connectivity-alz-deployment/platform-deployment/README.md](platform-connectivity-alz-deployment/platform-deployment/README.md)
- **Identity**: [platform-identity-alz-deployment/platform-deployment/README.md](platform-identity-alz-deployment/platform-deployment/README.md)
- **Management**: [platform-management-alz-deployment/platform-deployment/README.md](platform-management-alz-deployment/platform-deployment/README.md)
- **Security**: [platform-security-alz-deployment/platform-deployment/README.md](platform-security-alz-deployment/platform-deployment/README.md)
- **Shared Services**: [platform-sharedservices-alz-deployment/platform-deployment/README.md](platform-sharedservices-alz-deployment/platform-deployment/README.md)

## 🔐 Authentication

### OIDC (Recommended)
Uses OpenID Connect for keyless, secure authentication:
- No long-lived credentials needed
- Automatic token exchange
- Audit trail in Azure

### Setup OIDC
```bash
az ad app federated-identity-credential create \
  --id <APP_CLIENT_ID> \
  --parameters @- <<EOF
{
  "name": "github-oidc-alz",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:Gurkirats08/IaCtesting:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF
```

## 🛠️ Terraform State Management

Each platform uses Azure Storage Account for state management:

| Component | Details |
|---|---|
| **Backend Type** | Azure Storage Account (azurerm) |
| **State Files** | Separate per platform per environment |
| **Locking** | Automatic state locking via blob lease |
| **Encryption** | Storage account encryption enabled |
| **Access** | Service Principal / Managed Identity |

## 📊 Workflow Execution Flow

```
GitHub Actions Trigger
    ↓
Validate Job (parse inputs)
    ↓
Terraform Plan Job
    ├─ Checkout code
    ├─ Setup Terraform
    ├─ Azure Login (OIDC)
    ├─ Terraform Init
    ├─ Terraform Format
    ├─ Terraform Validate
    ├─ Terraform Plan
    └─ Upload Plan Artifact
    ↓
Approval Job (if action == apply/destroy)
    └─ Wait for environment approval
    ↓
Terraform Apply/Destroy Job
    ├─ Checkout code
    ├─ Download Plan Artifact
    ├─ Terraform Init
    └─ Terraform Apply/Destroy
    ↓
Deployment Summary
    └─ Generate GitHub Actions summary
```

## 🔄 Common Workflows

### Planning a deployment
```bash
cd platform-<platform>-alz-deployment/<platform>
terraform plan -var-file="<platform>.tfvars"
```

### Applying a deployment
```bash
terraform apply -var-file="<platform>.tfvars"
```

### Destroying resources
```bash
terraform destroy -var-file="<platform>.tfvars"
```

### Checking state
```bash
terraform state list
terraform state show <resource>
```

### State locking issues
```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>

# Check locks
terraform state list
```

## 📝 Variables & Configuration

### Backend Variables
Each platform has `backend.tfvars`:
```hcl
resource_group_name  = "rg-..."
storage_account_name = "st..."
container_name       = "...-state"
key                  = "terraform-<platform>.tfstate"
```

### Deployment Variables
Each platform has `<platform>.tfvars`:
```hcl
environment = "NonProduction"
mainLocation = "southeastasia"
resourceGroups = {
  # Resource groups...
}
# ... more variables
```

## 🚨 Troubleshooting

### State Lock Errors
```bash
cd platform-<platform>-alz-deployment/<platform>
terraform force-unlock <LOCK_ID>
```

### Module Path Errors
- Verify paths use `terraform-modules` (not `terraform-modules-hub`)
- Check all module sources are consistent

### Authentication Errors
- Verify OIDC credentials configured
- Check Azure permissions for Service Principal
- Ensure federated identity credentials are created

### Terraform Validation Errors
- Run `terraform validate` to check syntax
- Run `terraform fmt -recursive` to format code
- Check all required variables are defined in `.tfvars`

## 📞 Support & Documentation

- **GitHub Actions Setup**: See [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)
- **Platform Guides**: See individual `platform-deployment/README.md` files
- **Terraform Docs**: [terraform.io](https://www.terraform.io/docs)
- **Azure Provider**: [registry.terraform.io/providers/hashicorp/azurerm](https://registry.terraform.io/providers/hashicorp/azurerm)

## 🔄 Deployment Order (Recommended)

1. **Connectivity** - Deploy hub network infrastructure first
2. **Security** - Deploy security controls and compliance
3. **Identity** - Deploy identity and access management
4. **Management** - Deploy management and monitoring
5. **Shared Services** - Deploy shared services and common resources

## ✅ Best Practices

- ✅ Always run `terraform plan` before `apply`
- ✅ Review plan output carefully
- ✅ Use environment approvals for production
- ✅ Keep separate state files per platform
- ✅ Lock state during operations
- ✅ Use consistent variable naming
- ✅ Document custom modifications
- ✅ Test in non-production first
- ✅ Maintain RBAC least privilege
- ✅ Enable audit logging

## 📅 Version History

- **v1.0** (2026-02-05)
  - Initial ALZ deployment setup
  - 5 platform subscriptions
  - GitHub Actions workflows for each platform
  - OIDC authentication
  - Backend state management

---

**Last Updated**: February 5, 2026  
**Repository**: [Gurkirats08/IaCtesting](https://github.com/Gurkirats08/IaCtesting)
