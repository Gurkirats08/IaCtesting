# ARM_CLIENT_ID Credential Management - Quick Reference

## TL;DR - Recommended Approach

Use **GitHub Environments** with **separate service principals per subscription**:

```
┌─────────────────────────────────────────┐
│ 5 Azure Subscriptions                   │
├─────────────────────────────────────────┤
│ Connectivity → ServicePrincipal-1       │
│ Identity → ServicePrincipal-2           │
│ Management → ServicePrincipal-3         │
│ Security → ServicePrincipal-4           │
│ SharedServices → ServicePrincipal-5     │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ GitHub Environments (5 total)           │
├─────────────────────────────────────────┤
│ NonProduction-Connectivity              │
│ NonProduction-Identity                  │
│ NonProduction-Management                │
│ NonProduction-Security                  │
│ NonProduction-SharedServices            │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ Each Environment Secrets                │
├─────────────────────────────────────────┤
│ AZURE_CLIENT_ID                         │
│ AZURE_TENANT_ID                         │
│ AZURE_SUBSCRIPTION_ID                   │
└─────────────────────────────────────────┘
```

## Setup Checklist (15 minutes)

### Automated Setup (Recommended)

**PowerShell (Windows):**
```powershell
.\setup-credentials.ps1
```

**Bash (Linux/Mac):**
```bash
chmod +x setup-credentials.sh
./setup-credentials.sh
```

### Manual Setup

#### 1. Create Service Principals (5 minutes)

```bash
# For each subscription:
az account set --subscription "Connectivity"

# Create SP
az ad app create --display-name "github-alz-connectivity-sp" \
  --query appId -o tsv > connectivity_client_id.txt

# Create SP object
az ad sp create --id $(cat connectivity_client_id.txt)

# Grant role
az role assignment create \
  --assignee $(cat connectivity_client_id.txt) \
  --role "Contributor" \
  --scope "/subscriptions/$(az account show --query id -o tsv)"
```

Repeat for: Identity, Management, Security, SharedServices

#### 2. Set Up Federated Credentials (5 minutes)

```bash
# For each service principal and environment:
CLIENT_ID=$(cat connectivity_client_id.txt)

az ad app federated-identity-credential create \
  --id $CLIENT_ID \
  --parameters @- <<EOF
{
  "name": "github-connectivity",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:Gurkirats08/IaCtesting:environment:NonProduction-Connectivity",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF
```

#### 3. Create GitHub Environments (3 minutes)

1. Go to **Settings** → **Environments**
2. Click **New environment**
3. Name: `NonProduction-Connectivity`
4. Click **Create environment**
5. Add these secrets:
   - `AZURE_CLIENT_ID`: (from step 1)
   - `AZURE_TENANT_ID`: (from `az account show --query tenantId`)
   - `AZURE_SUBSCRIPTION_ID`: (from `az account show --query id`)
6. Repeat for all 5 subscriptions

#### 4. Update Workflow Files (2 minutes)

```yaml
jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    environment: NonProduction-Connectivity  # ← Add this line
    permissions:
      id-token: write
      contents: read
    steps:
      # ... rest of steps unchanged
```

Repeat for all 6 workflow files.

## Credential Management

### View Current Credentials

```bash
# List all service principals used
az ad app list --display-name "github-alz-*" \
  --query "[].{name: displayName, id: appId}" -o table

# Check role assignments
az role assignment list --all \
  --query "[?principalName | contains('github-alz')]" -o table
```

### Rotate Credentials (90-day cycle)

```bash
# 1. Get new credentials
az ad app credential reset --id $CLIENT_ID \
  --query "{password: password, clientId: appId}" -o json

# 2. Update GitHub Environment secrets:
#    Settings → Environments → [Environment] → Secrets
#    Update AZURE_CLIENT_ID, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID

# 3. Verify new credentials work by running a test workflow

# 4. Remove old credentials
az ad app credential delete --id $CLIENT_ID --key-id $OLD_KEY_ID
```

### Revoke Access

```bash
# Delete service principal
az ad sp delete --id $CLIENT_ID

# Delete app registration
az ad app delete --id $CLIENT_ID
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Subscription not found" | Verify subscription name: `az account list --output table` |
| "Access denied" | Grant Contributor role: `az role assignment create --assignee $CLIENT_ID --role "Contributor"` |
| "OIDC token validation failed" | Verify federated credential: `az ad app federated-identity-credential list --id $CLIENT_ID` |
| Workflow waits for runner | Check GitHub Environment exists: Settings → Environments |
| "No secrets found" | Verify secrets in Environment (not Repository): Settings → Environments → [Name] → Secrets |

## Security Best Practices

✅ **DO:**
- Use separate service principals per subscription
- Use OIDC (Federated Credentials) instead of secrets
- Rotate credentials every 90 days
- Use GitHub Environments for access control
- Enable audit logging for all deployments
- Restrict role scope to specific subscriptions

❌ **DON'T:**
- Use a shared service principal for all subscriptions
- Store credentials in code or variables
- Use hardcoded client secrets
- Store credentials in repository secrets (use Environments)
- Use overly permissive roles (Owner, Account Admin)

## Files & Documentation

| File | Purpose |
|------|---------|
| [MULTI_SUBSCRIPTION_CREDENTIALS.md](MULTI_SUBSCRIPTION_CREDENTIALS.md) | Comprehensive guide (all options & details) |
| [setup-credentials.ps1](setup-credentials.ps1) | Automated setup (PowerShell) |
| [setup-credentials.sh](setup-credentials.sh) | Automated setup (Bash) |
| [Workflow files](.github/workflows/) | Updated with environment references |

## Credential Storage Decision Matrix

| Scenario | Recommended Approach | Why |
|----------|----------------------|-----|
| Multi-subscription (your case) | GitHub Environments + separate SPs | ✅ Security, auditability, rotation |
| Single subscription | GitHub Secrets (Repository-level) | ✅ Simple, sufficient for one sub |
| Federated deployments | GitHub Environments per federation | ✅ Organization & governance |
| Development only | Local .env files (git-ignored) | ✅ Convenience, no GitHub required |

## Next Steps

1. **Run setup script** (PowerShell or Bash)
2. **Verify credentials** in GitHub Environments
3. **Update workflow files** to reference environments
4. **Test with a workflow** (run plan operation)
5. **Set up credential rotation** reminder (90 days)
6. **Document access** for your team

## Quick Test

```bash
# Test if credentials work:
az login --service-principal \
  -u $(echo $AZURE_CLIENT_ID) \
  --tenant $(echo $AZURE_TENANT_ID)

# If using OIDC (which you should):
# No password/secret needed - GitHub provides OIDC token
```

---

**Status**: ✅ Ready to implement
**Estimated Setup Time**: 15-20 minutes (manual) or 5 minutes (automated)
**Security Level**: ⭐⭐⭐⭐⭐ (OIDC + separate SPs per subscription)
