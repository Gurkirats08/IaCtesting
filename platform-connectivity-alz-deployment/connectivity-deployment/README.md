# Connectivity Platform Deployment

This directory contains deployment configurations and references for the Connectivity platform.

## Workflow Location
The GitHub Actions workflow for this platform is located at:
- [.github/workflows/alz-deployment.yml](../../../.github/workflows/alz-deployment.yml)

## Backend Configuration
Terraform backend configuration:
- File: `../connectivity/backend.tfvars`
- Storage Account: `stphiconndevopseus033`
- Container: `connectivity-state`
- Resource Group: `rg-devops-phi-conn-eus-033`

## Deployment Variables
- File: `../connectivity-deployment/variables.yaml` (for Azure Pipelines - reference only)
- Terraform Variables: `../connectivity/connectivity.tfvars`

## How to Deploy

### Via GitHub Actions (Recommended)
1. Go to **Actions** → **ALZ Connectivity Deployment**
2. Click **Run workflow**
3. Select Environment and Action (plan/apply)
4. Review and approve

### Locally via Terraform
```bash
cd ../connectivity

# Initialize
terraform init -backend-config="backend.tfvars"

# Plan
terraform plan -var-file="connectivity.tfvars" -out=tfplan

# Apply
terraform apply tfplan

# Destroy (if needed)
terraform destroy -var-file="connectivity.tfvars"
```

## Files Structure
```
connectivity-alz-deployment/
├── platform-deployment/          (this directory)
│   └── README.md
├── connectivity/                 (Terraform code)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── backend.tfvars
│   └── connectivity.tfvars
└── connectivity-deployment/      (Legacy Azure Pipelines config)
    ├── pipeline.yaml
    └── variables.yaml
```

## Authentication
Uses OIDC (OpenID Connect) for secure, keyless authentication to Azure.

## Support
For issues or questions, check the main README.md in the repository root.
