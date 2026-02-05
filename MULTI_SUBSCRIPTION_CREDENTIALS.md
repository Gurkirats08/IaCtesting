# Multi-Subscription Credential Management Guide

## Overview

For managing Azure Landing Zone deployments across 5 different subscriptions, you need a secure strategy for storing and rotating credentials. This guide covers the best practices for your multi-subscription setup.

## Current Setup

Your repository has 5 Azure subscriptions:

| Platform | Subscription | Workflow |
|----------|-------------|----------|
| **Connectivity** | Connectivity Sub | alz-connectivity.yml |
| **Identity** | Identity Sub | alz-identity.yml |
| **Management** | Management Sub | alz-management.yml |
| **Security** | Security Sub | alz-security.yml |
| **Shared Services** | Shared Services Sub | alz-sharedservices.yml |

## Credential Storage Strategies

### Option 1: Environment-Based Secrets (RECOMMENDED)

**Best for**: Different credentials per subscription, enhanced security, team organization.

#### Setup in GitHub

Create separate GitHub Environments for each subscription:

```
Settings → Environments
├── NonProduction-Connectivity
│   ├── AZURE_CLIENT_ID
│   ├── AZURE_TENANT_ID
│   └── AZURE_SUBSCRIPTION_ID
├── NonProduction-Identity
│   ├── AZURE_CLIENT_ID
│   ├── AZURE_TENANT_ID
│   └── AZURE_SUBSCRIPTION_ID
├── NonProduction-Management
│   ├── AZURE_CLIENT_ID
│   ├── AZURE_TENANT_ID
│   └── AZURE_SUBSCRIPTION_ID
├── NonProduction-Security
│   ├── AZURE_CLIENT_ID
│   ├── AZURE_TENANT_ID
│   └── AZURE_SUBSCRIPTION_ID
└── NonProduction-SharedServices
    ├── AZURE_CLIENT_ID
    ├── AZURE_TENANT_ID
    └── AZURE_SUBSCRIPTION_ID
```

#### Implementation

Update your workflows to use environment-specific variables:

```yaml
jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Add environment
    permissions:
      id-token: write
      contents: read
    env:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

**Advantages**:
- ✅ Different credentials per subscription
- ✅ Separate approval gates per environment
- ✅ Audit trail per subscription
- ✅ Easy credential rotation
- ✅ Team-based access control

**Disadvantages**:
- Requires manual GitHub environment creation (one-time)
- More secrets to manage

---

### Option 2: Subscription-Specific Named Secrets (ALTERNATIVE)

**Best for**: Single Azure Tenant, centralized credential management.

#### Setup in GitHub

Create secrets with subscription prefixes in **Settings → Secrets and variables → Actions**:

```
Repository Secrets:
├── CONNECTIVITY_CLIENT_ID
├── CONNECTIVITY_TENANT_ID
├── CONNECTIVITY_SUBSCRIPTION_ID
├── IDENTITY_CLIENT_ID
├── IDENTITY_TENANT_ID
├── IDENTITY_SUBSCRIPTION_ID
├── MANAGEMENT_CLIENT_ID
├── MANAGEMENT_TENANT_ID
├── MANAGEMENT_SUBSCRIPTION_ID
├── SECURITY_CLIENT_ID
├── SECURITY_TENANT_ID
├── SECURITY_SUBSCRIPTION_ID
├── SHAREDSERVICES_CLIENT_ID
├── SHAREDSERVICES_TENANT_ID
└── SHAREDSERVICES_SUBSCRIPTION_ID
```

#### Implementation

Update workflows to use subscription-specific secrets:

```yaml
env:
  TERRAFORM_VERSION: "1.6.0"

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    env:
      AZURE_CLIENT_ID: ${{ secrets.CONNECTIVITY_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.CONNECTIVITY_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.CONNECTIVITY_SUBSCRIPTION_ID }}
```

**Advantages**:
- ✅ All secrets in one place
- ✅ Clear naming convention
- ✅ Easy to list all credentials

**Disadvantages**:
- ❌ No separate approval gates
- ❌ Harder to rotate individual credentials
- ❌ No per-subscription access control

---

### Option 3: Shared Tenant Secret with Dynamic Subscription Selection (NOT RECOMMENDED)

**Setup**: Single service principal that can access all subscriptions

```yaml
Repository Secrets:
├── AZURE_CLIENT_ID (shared across all subscriptions)
├── AZURE_TENANT_ID (shared across all subscriptions)
```

Then pass subscription ID per workflow:

```yaml
env:
  AZURE_SUBSCRIPTION_ID: ${{ secrets.CONNECTIVITY_SUBSCRIPTION_ID }}
```

**Disadvantages**:
- ❌ Single point of failure
- ❌ Hard to audit which subscription was used
- ❌ Difficult to restrict access
- ❌ Security risk if compromised

---

## Recommended: Option 1 - Environment-Based Secrets

### Step-by-Step Implementation

#### Step 1: Create Azure Service Principals

For each subscription, create a service principal:

```bash
# For Connectivity subscription
az ad app create --display-name "github-alz-connectivity-sp"
az ad sp create --id <APP_ID>

# Get the credentials
CONNECTIVITY_CLIENT_ID=$(az ad app list --display-name "github-alz-connectivity-sp" --query "[0].appId" -o tsv)
CONNECTIVITY_TENANT_ID=$(az account show --query tenantId -o tsv)
CONNECTIVITY_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Repeat for each subscription...
```

#### Step 2: Set Up Federated Identity Credentials (OIDC)

For each service principal, create a federated credential:

```bash
az ad app federated-identity-credential create \
  --id $CONNECTIVITY_CLIENT_ID \
  --parameters @- <<EOF
{
  "name": "github-alz-connectivity",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:Gurkirats08/IaCtesting:environment:NonProduction-Connectivity",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF

# Do this for each environment:
# - repo:Gurkirats08/IaCtesting:environment:NonProduction-Connectivity
# - repo:Gurkirats08/IaCtesting:environment:NonProduction-Identity
# - repo:Gurkirats08/IaCtesting:environment:NonProduction-Management
# - repo:Gurkirats08/IaCtesting:environment:NonProduction-Security
# - repo:Gurkirats08/IaCtesting:environment:NonProduction-SharedServices
```

#### Step 3: Create GitHub Environments

In your repository:

1. Go to **Settings** → **Environments**
2. Click **New environment**
3. Name: `NonProduction-Connectivity`
4. Add secrets:
   - `AZURE_CLIENT_ID`: (from step 1)
   - `AZURE_TENANT_ID`: (from step 1)
   - `AZURE_SUBSCRIPTION_ID`: (from step 1)
5. Repeat for all 5 subscriptions

#### Step 4: Update Workflows

Update each workflow to reference the environment:

```yaml
# alz-connectivity.yml
jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Add this
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Azure Login (OIDC)
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

#### Step 5: Update All Workflows

Apply the same pattern to all workflows:

| Workflow | Environment |
|----------|-------------|
| alz-connectivity.yml | NonProduction-Connectivity |
| alz-identity.yml | NonProduction-Identity |
| alz-management.yml | NonProduction-Management |
| alz-security.yml | NonProduction-Security |
| alz-sharedservices.yml | NonProduction-SharedServices |

### Workflow Structure with Environments

```yaml
name: ALZ Connectivity Deployment

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Select Environment'
        required: true
        default: 'NonProduction'
        type: choice
        options:
          - NonProduction

env:
  TERRAFORM_VERSION: "1.6.0"
  TF_INPUT: false
  TF_IN_AUTOMATION: true

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← GitHub Environment
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Azure Login (OIDC)
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform Init
        working-directory: ./platform-connectivity-alz-deployment/connectivity
        env:
          ARM_USE_OIDC: true
          ARM_OIDC_TOKEN: ${{ env.ACTIONS_ID_TOKEN_REQUEST_TOKEN }}
          ARM_OIDC_TOKEN_REQUEST_URL: ${{ env.ACTIONS_ID_TOKEN_REQUEST_URL }}
          ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
          ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        run: terraform init -backend-config="backend.tfvars"

  approval:
    needs: terraform-plan
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Same environment for approval
    if: github.event.inputs.action == 'apply' || github.event.inputs.action == 'destroy'
    steps:
      - name: Approval Checkpoint
        run: echo "✅ Approval granted for connectivity deployment"

  terraform-apply:
    needs: approval
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Same environment for apply
    if: github.event.inputs.action == 'apply'
    # ... rest of apply steps
```

## Credential Rotation Strategy

### Regular Rotation Schedule

- **Every 90 days**: Rotate all service principal credentials
- **Monthly**: Review access logs
- **Immediately**: If credentials are suspected to be compromised

### Rotation Steps

```bash
# 1. Create new credentials for the service principal
az ad app credential reset --id $CLIENT_ID

# 2. Update GitHub Environment secrets:
#    Settings → Environments → [Environment] → Secrets
#    Update AZURE_CLIENT_ID, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID

# 3. Verify new credentials work:
#    Run a test workflow

# 4. Remove old credentials after verification:
az ad app credential delete --id $CLIENT_ID --key-id $OLD_KEY_ID
```

## Security Best Practices

### 1. Principle of Least Privilege

Each service principal should have **only the minimum required permissions**:

```bash
# Grant only necessary roles per subscription
az role assignment create \
  --assignee $CLIENT_ID \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

# For more granular control, use custom roles:
az role assignment create \
  --assignee $CLIENT_ID \
  --role "Custom-Terraform-Deployer" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"
```

### 2. Audit & Monitoring

Enable audit logging for all deployments:

```bash
# Enable activity logs
az monitor activity-log list \
  --subscription $SUBSCRIPTION_ID \
  --query "[?properties.caller=='$CLIENT_ID']" \
  --output table
```

### 3. Network Isolation

Use GitHub Actions environments with IP restrictions (if available in your GitHub plan):

```yaml
environment:
  name: NonProduction-Connectivity
  deployment-branch-policy:
    protected-branches-only: false
```

### 4. Secret Scanning

Enable GitHub's secret scanning:

**Settings** → **Security & analysis** → **Enable secret scanning**

### 5. Multi-Factor for OIDC

Federated credentials eliminate the need for storing client secrets:

```
GitHub Actions → Azure (OIDC Token) → Azure AD
                                      (No stored secrets)
```

This is inherently more secure than storing secrets.

## Troubleshooting Multi-Subscription Deployments

### Issue: "Subscription not found"

```bash
# Verify subscription exists and is accessible
az account list --output table

# Switch to correct subscription
az account set --subscription $SUBSCRIPTION_ID
```

### Issue: "Insufficient permissions"

```bash
# Check role assignments
az role assignment list \
  --assignee $CLIENT_ID \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

# Add required role
az role assignment create \
  --assignee $CLIENT_ID \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"
```

### Issue: "OIDC token validation failed"

```bash
# Verify federated credential configuration
az ad app federated-identity-credential list --id $CLIENT_ID

# Check if subject matches GitHub environment exactly
# Should be: repo:Gurkirats08/IaCtesting:environment:NonProduction-Connectivity
```

### Issue: "Cannot access secrets in environment"

```bash
# Verify environment exists
# Settings → Environments

# Verify secrets are set in the environment (not repository)
# Secrets in Environments override Repository secrets
```

## Migration Path from Repository Secrets to Environment Secrets

If you currently use Repository-level secrets:

### Step 1: Create Environments and Add Secrets

1. Create `NonProduction-Connectivity` environment
2. Add `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` secrets
3. Repeat for all 5 subscriptions

### Step 2: Update Workflows

Add `environment:` to each job that needs authentication:

```yaml
jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Add this line
    # ... rest of job config
```

### Step 3: Test

Run workflows to verify they use environment secrets instead of repository secrets.

### Step 4: Cleanup

Delete old repository-level secrets once all workflows are using environment secrets.

## Summary Table: Credential Management Strategies

| Strategy | Security | Scalability | Auditability | Ease of Use | Recommended |
|----------|----------|-------------|--------------|-------------|------------|
| **Option 1: Environments** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ YES |
| **Option 2: Named Secrets** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⚠️ Maybe |
| **Option 3: Shared Secret** | ⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ | ❌ NO |

---

## Quick Reference: Credential Checklist

- [ ] Create 5 Azure Service Principals (one per subscription)
- [ ] Set up Federated Identity Credentials (OIDC) for each SP
- [ ] Create 5 GitHub Environments (NonProduction-*)
- [ ] Add AZURE_CLIENT_ID to each environment
- [ ] Add AZURE_TENANT_ID to each environment
- [ ] Add AZURE_SUBSCRIPTION_ID to each environment
- [ ] Update all 6 workflow files with `environment:` directive
- [ ] Test each workflow with a plan operation
- [ ] Set up credential rotation reminders (90 days)
- [ ] Enable audit logging for deployments

---

**Recommendation**: Implement **Option 1 (Environment-Based Secrets)** for maximum security, auditability, and flexibility in your multi-subscription setup.
