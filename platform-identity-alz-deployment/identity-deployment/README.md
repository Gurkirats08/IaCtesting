# Identity Platform Deployment

This directory contains deployment configurations and references for the Identity platform.

## Workflow Location
The GitHub Actions workflow for this platform is located at:
- [.github/workflows/alz-identity.yml](../../../.github/workflows/alz-identity.yml)

## Backend Configuration
Terraform backend configuration:
- File: `../identity_dev/backend.tfvars`
- Storage Account: `stphiidntdevopstest3131`
- Container: `identity-state`
- Resource Group: `rg-devops-phi-idnt-test31`

## Deployment Variables
- File: `../identity-deployment/variables.yaml` (for Azure Pipelines - reference only)
- Terraform Variables: `../identity_dev/identity.tfvars`

## How to Deploy

### Via GitHub Actions (Recommended)
1. Go to **Actions** → **ALZ Identity Deployment**
2. Click **Run workflow**
3. Select Environment and Action (plan/apply)
4. Review and approve

### Locally via Terraform
```bash
cd ../identity_dev

# Initialize
terraform init -backend-config="backend.tfvars"

# Plan
terraform plan -var-file="identity.tfvars" -out=tfplan

# Apply
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="identity.tfvars"
```

## Files Structure
```
identity-alz-deployment/
├── platform-deployment/          (this directory)
│   └── README.md
├── identity_dev/                 (Terraform code)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── backend.tfvars
│   └── identity.tfvars
└── identity-deployment/          (Legacy Azure Pipelines config)
    ├── pipeline.yaml
    └── variables.yaml
```

## Authentication
Uses OIDC (OpenID Connect) for secure, keyless authentication to Azure.

## Support
For issues or questions, check the main README.md in the repository root.
