# Credential Storage Architecture for Multi-Subscription Deployments

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                        │
│                   (Gurkirats08/IaCtesting)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              Workflow Dispatch Trigger                    │  │
│  │  (Run: connectivity, identity, management, etc.)         │  │
│  └────────────────────┬────────────────────────────────────┘  │
│                       │                                        │
│                       ▼                                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           GitHub Environments (5 total)                  │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ NonProduction-Connectivity                         │  │  │
│  │  │ ├─ AZURE_CLIENT_ID: sp-connectivity-uuid           │  │  │
│  │  │ ├─ AZURE_TENANT_ID: tenant-guid                    │  │  │
│  │  │ └─ AZURE_SUBSCRIPTION_ID: conn-sub-guid            │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ NonProduction-Identity                             │  │  │
│  │  │ ├─ AZURE_CLIENT_ID: sp-identity-uuid               │  │  │
│  │  │ ├─ AZURE_TENANT_ID: tenant-guid                    │  │  │
│  │  │ └─ AZURE_SUBSCRIPTION_ID: idnt-sub-guid            │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ NonProduction-Management                           │  │  │
│  │  │ ├─ AZURE_CLIENT_ID: sp-management-uuid             │  │  │
│  │  │ ├─ AZURE_TENANT_ID: tenant-guid                    │  │  │
│  │  │ └─ AZURE_SUBSCRIPTION_ID: mgmt-sub-guid            │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ NonProduction-Security                             │  │  │
│  │  │ ├─ AZURE_CLIENT_ID: sp-security-uuid               │  │  │
│  │  │ ├─ AZURE_TENANT_ID: tenant-guid                    │  │  │
│  │  │ └─ AZURE_SUBSCRIPTION_ID: sec-sub-guid             │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ NonProduction-SharedServices                       │  │  │
│  │  │ ├─ AZURE_CLIENT_ID: sp-sharedservices-uuid         │  │  │
│  │  │ ├─ AZURE_TENANT_ID: tenant-guid                    │  │  │
│  │  │ └─ AZURE_SUBSCRIPTION_ID: shared-sub-guid          │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │          Workflow Files (Updated)                         │  │
│  │                                                           │  │
│  │  ├─ alz-connectivity.yml                                 │  │
│  │  │   environment: NonProduction-Connectivity  ◄─────────┼─┐  │
│  │  │                                                    │ │  │  │
│  │  ├─ alz-identity.yml                                    │ │  │
│  │  │   environment: NonProduction-Identity  ◄────────────┼─┐  │
│  │  │                                                    │ │ │  │
│  │  ├─ alz-management.yml                                  │ │ │  │
│  │  │   environment: NonProduction-Management  ◄─────────┼─┐ │  │
│  │  │                                                    │ │ │ │  │
│  │  ├─ alz-security.yml                                    │ │ │ │  │
│  │  │   environment: NonProduction-Security  ◄───────────┼─┐ │ │  │
│  │  │                                                    │ │ │ │ │  │
│  │  └─ alz-sharedservices.yml                             │ │ │ │ │  │
│  │      environment: NonProduction-SharedServices  ◄──────┼─┐ │ │ │  │
│  │                                                        │ │ │ │ │ │  │
│  └────────────────────────────────┬───────────────────────┼─────────┘  │
│                                   │                       │            │
└─────────────────────────────────────────────────────────────────────────┘
                                  │                       │
                                  │                       │
                                  ▼                       ▼
                    ┌──────────────────────┐   ┌──────────────────────┐
                    │   GitHub Actions     │   │   GitHub Actions     │
                    │   Runner             │   │   Runner             │
                    │                      │   │                      │
                    │  Uses Secrets from   │   │  Uses Secrets from   │
                    │  Environment:        │   │  Environment:        │
                    │  NonProduction-*     │   │  NonProduction-*     │
                    │                      │   │                      │
                    │  OIDC Token:         │   │  OIDC Token:         │
                    │  (No stored secret)  │   │  (No stored secret)  │
                    └──────────────┬───────┘   └──────────────┬───────┘
                                   │                         │
                                   ▼                         ▼
                    ┌──────────────────────┐   ┌──────────────────────┐
                    │   Azure AD           │   │   Azure AD           │
                    │   Federation         │   │   Federation         │
                    │                      │   │                      │
                    │  Validates OIDC      │   │  Validates OIDC      │
                    │  Token               │   │  Token               │
                    │                      │   │                      │
                    │  Issues Access Token │   │  Issues Access Token │
                    └──────────────┬───────┘   └──────────────┬───────┘
                                   │                         │
                                   ▼                         ▼
                    ┌──────────────────────┐   ┌──────────────────────┐
                    │   Azure Subscription │   │   Azure Subscription │
                    │   (Connectivity)     │   │   (Identity/etc)     │
                    │                      │   │                      │
                    │  Service Principal   │   │  Service Principal   │
                    │  Deployed Resource   │   │  Deployed Resource   │
                    │  - VNets, NSGs, etc  │   │  - AD configs, etc   │
                    └──────────────────────┘   └──────────────────────┘
```

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Request Flow                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. Developer triggers workflow                                     │
│     └─ Selects: Environment → Action (plan/apply/destroy)          │
│                                                                     │
│  2. Workflow executes on GitHub Actions Runner                     │
│     ├─ Reads: Secrets from GitHub Environment                      │
│     │          (AZURE_CLIENT_ID, AZURE_TENANT_ID, etc)             │
│     │                                                               │
│     └─ Calls: Azure Login (OIDC)                                   │
│                                                                     │
│  3. Azure AD processes OIDC Token                                   │
│     ├─ Validates: Token signature & origin (GitHub Actions)       │
│     ├─ Verifies: Subject = repo:owner/repo:environment:*          │
│     └─ Issues: Short-lived Access Token                            │
│                                                                     │
│  4. Terraform uses Access Token                                     │
│     ├─ Authenticates: ARM_CLIENT_ID, ARM_TENANT_ID                │
│     ├─ Accesses: Azure Subscription (ARM_SUBSCRIPTION_ID)         │
│     └─ Deploys: Resources (VNets, RGs, etc)                        │
│                                                                     │
│  5. Audit Log recorded                                              │
│     └─ Who: Service Principal                                      │
│        When: Timestamp                                             │
│        What: Resource created/modified                             │
│        Where: Subscription & Resource Group                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Security Layers

```
┌────────────────────────────────────────────────────────────┐
│ Layer 1: GitHub Level                                      │
├────────────────────────────────────────────────────────────┤
│ • Repository Access Control (OAuth)                         │
│ • Environment-level Secrets (encrypted at rest)            │
│ • Required Reviewers (approval gates)                      │
│ • Deployment branch policies                               │
│ • IP allowlisting (GitHub Enterprise)                      │
└────────────────────────────────────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 2: GitHub Actions → Azure                            │
├────────────────────────────────────────────────────────────┤
│ • OIDC Token (no static credentials stored)               │
│ • Federated Identity Credential verification               │
│ • Short-lived token (1 hour expiry)                        │
│ • TLS encryption in transit                               │
└────────────────────────────────────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 3: Azure Level                                       │
├────────────────────────────────────────────────────────────┤
│ • Service Principal per subscription                       │
│ • Role-Based Access Control (RBAC)                        │
│ • Scope limited to specific subscriptions                  │
│ • Activity logging & monitoring                           │
│ • Multi-factor authentication (optional)                   │
└────────────────────────────────────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 4: Deployment                                        │
├────────────────────────────────────────────────────────────┤
│ • Terraform state encryption                              │
│ • State lock management                                    │
│ • Resource tagging for audit trail                         │
│ • Approval gates before apply                             │
└────────────────────────────────────────────────────────────┘
```

## Credential Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│  90-Day Credential Rotation Cycle                           │
└─────────────────────────────────────────────────────────────┘

    Day 1                 Day 45                Day 90
    ├─ Create new SP      ├─ Verify working    ├─ Rotate again
    ├─ Setup OIDC         └─ No issues         ├─ Decommission old
    └─ Add to GitHub         expected          └─ Document change

    ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
    │ Active Period    │  │ In Use           │  │ Deprecation      │
    │ Days 1-90        │  │ Days 1-90        │  │ Days 81-90       │
    │                  │  │                  │  │                  │
    │ ✓ SP Created     │  │ ✓ Workflows use  │  │ ⚠ Prepare new    │
    │ ✓ OIDC enabled   │  │ ✓ No errors      │  │ ⚠ Test new       │
    │ ✓ GitHub Secrets │  │ ✓ Audit clean    │  │ ⚠ Schedule rotation
    │ ✓ Testing Done   │  │ ✓ Usage monitored│  │ ✓ Communication  │
    └──────────────────┘  └──────────────────┘  └──────────────────┘

Plan your rotation: Set calendar reminder for Day 80
```

## Comparison: Credential Storage Options

```
┌──────────────────────────────────────────────────────────────────┐
│ OPTION 1: GitHub Environments (RECOMMENDED)                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Setup:                                                          │
│    ┌─ GitHub Environment: NonProduction-Connectivity           │
│    ├─ GitHub Environment: NonProduction-Identity               │
│    ├─ GitHub Environment: NonProduction-Management             │
│    ├─ GitHub Environment: NonProduction-Security               │
│    └─ GitHub Environment: NonProduction-SharedServices         │
│                                                                  │
│  Secrets per Environment:                                       │
│    ├─ AZURE_CLIENT_ID       (separate per environment)         │
│    ├─ AZURE_TENANT_ID       (shared)                           │
│    └─ AZURE_SUBSCRIPTION_ID (separate per environment)         │
│                                                                  │
│  Security: ⭐⭐⭐⭐⭐ (EXCELLENT)                                │
│  Scalability: ⭐⭐⭐⭐⭐ (EXCELLENT)                             │
│  Auditability: ⭐⭐⭐⭐⭐ (EXCELLENT)                            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│ OPTION 2: Named Repository Secrets                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Setup:                                                          │
│    └─ All Secrets at Repository Level:                          │
│       ├─ CONNECTIVITY_CLIENT_ID                                 │
│       ├─ CONNECTIVITY_TENANT_ID                                 │
│       ├─ CONNECTIVITY_SUBSCRIPTION_ID                           │
│       ├─ IDENTITY_CLIENT_ID                                     │
│       ├─ ... (15 secrets total)                                 │
│       └─ SHAREDSERVICES_SUBSCRIPTION_ID                         │
│                                                                  │
│  Security: ⭐⭐⭐ (MODERATE)                                     │
│  Scalability: ⭐⭐ (LIMITED)                                    │
│  Auditability: ⭐⭐⭐ (MODERATE)                                │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│ OPTION 3: Shared Service Principal (NOT RECOMMENDED)            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Setup:                                                          │
│    └─ Single SP for all subscriptions:                          │
│       ├─ AZURE_CLIENT_ID        (shared)                        │
│       ├─ AZURE_TENANT_ID        (shared)                        │
│       └─ AZURE_SUBSCRIPTION_ID  (per workflow, in tfvars)      │
│                                                                  │
│  Security: ⭐ (POOR)                                            │
│  Scalability: ⭐ (POOR)                                         │
│  Auditability: ⭐ (POOR)                                        │
│                                                                  │
│  Problems:                                                      │
│    ❌ Single point of failure                                   │
│    ❌ Hard to audit which subscription was accessed             │
│    ❌ Difficult to rotate credentials per subscription          │
│    ❌ Security risk if SP is compromised                        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Implementation Timeline

```
Week 1:
  Day 1: Create Service Principals (run automated script)
         Setup Federated Credentials for OIDC
  Day 2: Create GitHub Environments
         Add Secrets to Environments
  Day 3: Update Workflow Files
         Add environment: directives
  Day 4: Test each workflow
         Verify credentials work
  Day 5: Documentation & Training

Week 2:
  Monitor workflows for any issues
  Set up credential rotation reminders
  Document process for team
```

---

**Key Takeaway**: 
Use GitHub Environments with separate service principals per subscription for maximum security, auditability, and operational flexibility.
