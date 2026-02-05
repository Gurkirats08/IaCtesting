# Management Platform Deployment

This directory contains deployment configurations and references for the Management platform.

## Workflow Location
The GitHub Actions workflow for this platform is located at:
- [.github/workflows/alz-management.yml](../../../.github/workflows/alz-management.yml)

## Backend Configuration
Terraform backend configuration:
- File: `../management/backend.tfvars`
- Storage Account: `stmgmtdevopssea020`
- Container: `management-state`
- Resource Group: `rg-phi-devops-mgmt-sea-001`

## Deployment Variables
- File: `../management-deployment/variables.yaml` (for Azure Pipelines - reference only)
- Terraform Variables: `../management/management.tfvars`

## How to Deploy

### Via GitHub Actions (Recommended)
1. Go to **Actions** → **ALZ Management Deployment**
2. Click **Run workflow**
3. Select Environment and Action (plan/apply)
4. Review and approve

### Locally via Terraform
```bash
cd ../management

# Initialize
terraform init -backend-config="backend.tfvars"

# Plan
terraform plan -var-file="management.tfvars" -out=tfplan

# Apply
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="management.tfvars"
```

## Files Structure
```
management-alz-deployment/
├── platform-deployment/          (this directory)
│   └── README.md
├── management/                   (Terraform code)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── backend.tfvars
│   └── management.tfvars
└── management-deployment/        (Legacy Azure Pipelines config)
    ├── pipeline.yaml
    └── variables.yaml
```

## Authentication
Uses OIDC (OpenID Connect) for secure, keyless authentication to Azure.

## Support
For issues or questions, check the main README.md in the repository root.
