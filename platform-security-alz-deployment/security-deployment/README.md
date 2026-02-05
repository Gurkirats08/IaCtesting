# Security Platform Deployment

This directory contains deployment configurations and references for the Security platform.

## Workflow Location
The GitHub Actions workflow for this platform is located at:
- [.github/workflows/alz-security.yml](../../../.github/workflows/alz-security.yml)

## Backend Configuration
Terraform backend configuration:
- File: `../security/backend.tfvars`
- Storage Account: `stphisecdevopssea020`
- Container: `security-state`
- Resource Group: `rg-devops-sec-phi-sea-001`

## Deployment Variables
- File: `../security-deployment/variables.yaml` (for Azure Pipelines - reference only)
- Terraform Variables: `../security/security.tfvars`

## How to Deploy

### Via GitHub Actions (Recommended)
1. Go to **Actions** → **ALZ Security Deployment**
2. Click **Run workflow**
3. Select Environment and Action (plan/apply)
4. Review and approve

### Locally via Terraform
```bash
cd ../security

# Initialize
terraform init -backend-config="backend.tfvars"

# Plan
terraform plan -var-file="security.tfvars" -out=tfplan

# Apply
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="security.tfvars"
```

## Files Structure
```
security-alz-deployment/
├── platform-deployment/          (this directory)
│   └── README.md
├── security/                     (Terraform code)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── backend.tfvars
│   └── security.tfvars
└── security-deployment/          (Legacy Azure Pipelines config)
    ├── pipeline.yaml
    └── variables.yaml
```

## Authentication
Uses OIDC (OpenID Connect) for secure, keyless authentication to Azure.

## Support
For issues or questions, check the main README.md in the repository root.
