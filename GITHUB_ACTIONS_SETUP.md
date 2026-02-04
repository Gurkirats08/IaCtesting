# GitHub Actions ALZ Deployment Setup Guide

## Prerequisites

### 1. Azure Service Principal (SPN) Setup
Your SPN needs to have appropriate permissions for the environments it will deploy to.

### 2. Federated Identity Credentials for OIDC

Set up OIDC (OpenID Connect) authentication between GitHub and Azure for secure, keyless authentication:

```bash
# Variables
GITHUB_ORG="Gurkirats08"
GITHUB_REPO="IaCtesting"
GITHUB_REF="ref:refs/heads/main"  # or specific branch/tag
SUBJECT="repo:${GITHUB_ORG}/${GITHUB_REPO}:${GITHUB_REF}"

az ad app federated-identity-credential create \
  --id <YOUR_APP_CLIENT_ID> \
  --parameters @- <<EOF
{
  "name": "github-oidc-alz-deployment",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "${SUBJECT}",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF
```

For multiple branches/environments:

```bash
# For development branch
az ad app federated-identity-credential create \
  --id <YOUR_APP_CLIENT_ID> \
  --parameters @- <<EOF
{
  "name": "github-oidc-develop",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:${GITHUB_ORG}/${GITHUB_REPO}:ref:refs/heads/develop",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF

# For all refs (more permissive)
az ad app federated-identity-credential create \
  --id <YOUR_APP_CLIENT_ID> \
  --parameters @- <<EOF
{
  "name": "github-oidc-alz-all",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:${GITHUB_ORG}/${GITHUB_REPO}:*",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF
```

## GitHub Repository Secrets

Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions):

### Required Secrets

1. **AZURE_CLIENT_ID** (Service Principal Client ID)
   ```
   Your Azure AD App Registration Client ID
   ```

2. **AZURE_TENANT_ID** (Azure Tenant ID)
   ```
   Your Azure AD Tenant ID
   ```

3. **AZURE_SUBSCRIPTION_ID** (Azure Subscription ID)
   ```
   Your Azure Subscription ID
   ```

### How to Add Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the name and value

## Environment Configuration

### Create GitHub Environments for Manual Approval

1. Go to **Settings** → **Environments**
2. Create environments for each tier:
   - **Sandbox** (optional approval)
   - **Development** (optional approval)
   - **NonProduction** (requires approval)
   - **Production** (requires approval)

3. For each environment:
   - Click **Add protection rule**
   - Select **Required reviewers**
   - Add team members or specific users
   - (Optional) Set up deployment branches

## Terraform Backend Configuration

Ensure your Terraform backend variables are correctly set in each platform's deployment variables file:

**Example: connectivity-deployment/variables.yaml**
```yaml
variables:
  serviceConnection: external_tenant_Connectivity_Service_connection
  terraformStorageRG: rg-devops-sao-conn-eus-033
  terraformStorageAccount: stsaoconndevopseus033
  terraformStorageContainer: connectivity-state
```

The workflow extracts these values automatically.

## Usage

### Trigger the Workflow

1. Go to **Actions** → **ALZ Platform Deployment**
2. Click **Run workflow**
3. Fill in the parameters:
   - **Platform to Deploy**: Choose a specific platform or `all`
   - **Environment**: Select target environment
   - **Action**: Choose `plan` or `apply`
4. Click **Run workflow**

### Workflow Flow

```
1. Validate Job
   ├─ Parse inputs
   └─ Display configuration

2. Terraform Plan Job (Parallel for selected platform(s))
   ├─ Checkout code
   ├─ Setup Terraform
   ├─ Azure Login (OIDC)
   ├─ Terraform Init
   ├─ Terraform Format Check
   ├─ Terraform Validate
   ├─ Terraform Plan
   └─ Upload artifact

3. Approval Job (if action == 'apply')
   └─ Environment approval required

4. Terraform Apply Job (Parallel for selected platform(s))
   ├─ Download plan artifact
   ├─ Terraform Init
   └─ Terraform Apply

5. Summary Job
   └─ Generate deployment summary
```

## Key Features

✅ **Platform Selection**: Deploy single or all platforms  
✅ **Environment Support**: Sandbox, Dev, NonProd, Production  
✅ **Manual Approval**: Required for apply actions  
✅ **Parallel Execution**: Deploy multiple platforms simultaneously  
✅ **OIDC Authentication**: Secure, keyless authentication to Azure  
✅ **Plan Artifacts**: Saved plans for review and apply  
✅ **Comprehensive Validation**: Format, syntax, and policy checks  
✅ **Deployment Summary**: GitHub Actions summary with logs

## Troubleshooting

### OIDC Token Issues
- Ensure federated credentials are properly configured
- Check token request URL and format
- Verify Azure AD app permissions

### Terraform Backend Errors
- Verify storage account and container exist
- Check SPN has permissions to storage account
- Ensure correct RBAC assignments (Storage Blob Data Contributor)

### Plan or Apply Failures
- Check Terraform variable files exist (`<env>-<platform>.tfvars`)
- Review Terraform logs in workflow output
- Validate Azure resource quotas

### Environment Approval Not Triggering
- Ensure environment protection rules are configured
- Check user permissions for environment
- Review environment branch protection settings

## Security Best Practices

✅ Use OIDC instead of credentials  
✅ Implement approval requirements for production  
✅ Limit SPN permissions to minimum required  
✅ Rotate secrets regularly  
✅ Audit workflow execution logs  
✅ Use branch protection rules  
✅ Enable audit logging in Azure

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Login Action](https://github.com/azure/login)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [Federated Identity Credentials](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure)
