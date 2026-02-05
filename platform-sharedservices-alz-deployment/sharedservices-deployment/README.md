# Shared Services Platform Deployment

This directory contains deployment configurations and references for the Shared Services platform.

## Workflow Location
The GitHub Actions workflow for this platform is located at:
- [.github/workflows/alz-sharedservices.yml](../../../.github/workflows/alz-sharedservices.yml)

## Backend Configuration
Terraform backend configuration:
- File: `../sharedservices/backend.tfvars`
- Storage Account: `philiactestingsea01`
- Container: `iacstate`
- Resource Group: `philips-testing`

## Deployment Variables
- File: `../sharedservices-deployment/variables.yaml` (for Azure Pipelines - reference only)
- Terraform Variables: `../sharedservices/sharedservices.tfvars`

## How to Deploy

### Via GitHub Actions (Recommended)
1. Go to **Actions** → **ALZ Shared Services Deployment**
2. Click **Run workflow**
3. Select Environment and Action (plan/apply)
4. Review and approve

### Locally via Terraform
```bash
cd ../sharedservices

# Initialize
terraform init -backend-config="backend.tfvars"

# Plan
terraform plan -var-file="sharedservices.tfvars" -out=tfplan

# Apply
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="sharedservices.tfvars"
```

## Files Structure
```
sharedservices-alz-deployment/
├── platform-deployment/          (this directory)
│   └── README.md
├── sharedservices/               (Terraform code)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── backend.tfvars
│   └── sharedservices.tfvars
└── sharedservices-deployment/    (Legacy Azure Pipelines config)
    ├── pipeline.yaml
    └── variables.yaml
```

## Authentication
Uses OIDC (OpenID Connect) for secure, keyless authentication to Azure.

## Support
For issues or questions, check the main README.md in the repository root.
