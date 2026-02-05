# GitHub Self-Hosted Runner Setup Guide

This guide provides instructions for setting up and configuring self-hosted runners for the Azure Landing Zone (ALZ) deployment workflows.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setting Up Self-Hosted Runners](#setting-up-self-hosted-runners)
- [Runner Configuration](#runner-configuration)
- [Health Checks](#health-checks)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before setting up self-hosted runners, ensure you have:

- GitHub repository admin access
- Linux machine (Ubuntu 20.04 or later recommended)
- Internet connectivity to GitHub
- Required software:
  - Git
  - Terraform 1.6.0+
  - Azure CLI
  - PowerShell 7+

### Required Permissions

- GitHub: Repository Settings access to add runners
- Azure: Service Principal with appropriate permissions for deployments
- Linux: Sudo access for system configuration

## Setting Up Self-Hosted Runners

### Step 1: Create a GitHub Personal Access Token (PAT)

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token**
3. Configure scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `admin:org_hook` (Write access to hooks)
   - ✅ `workflow` (Update GitHub Action workflows)
4. Click **Generate token**
5. **Copy and save the token securely** (you won't see it again)

### Step 2: Add Runner to GitHub Repository

1. Navigate to your repository: `Gurkirats08/IaCtesting`
2. Go to **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Select:
   - **OS**: Linux
   - **Architecture**: X64 (or ARM64 if applicable)
5. Follow GitHub's download and configuration instructions

### Step 3: Download and Configure Runner

```bash
# Create a directory for the runner
mkdir actions-runner && cd actions-runner

# Download the latest runner
curl -o actions-runner-linux-x64-2.320.0.tar.gz \
  -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz

# Extract the runner
tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz

# Verify installation
./bin/Runner.Listener --version
```

### Step 4: Register the Runner

```bash
# Navigate to runner directory
cd ~/actions-runner

# Configure the runner (use the token from Step 1)
./config.sh --url https://github.com/Gurkirats08/IaCtesting \
  --token YOUR_GITHUB_TOKEN \
  --name my-self-hosted-runner \
  --runnergroup Default \
  --labels self-hosted,linux,terraform,azure

# Follow the prompts to complete configuration
```

**Configuration Options:**

```
Enter the name of runner: my-self-hosted-runner
Enter any additional labels (comma separated): self-hosted,linux,terraform,azure
Enter name of work folder: _work
```

### Step 5: Install as a Service (Recommended)

**For Linux systems using systemd:**

```bash
# Install as system service
sudo ./svc.sh install

# Start the service
sudo ./svc.sh start

# Check status
sudo ./svc.sh status

# View logs
sudo journalctl -u actions.runner.* -f
```

**For manual running (development/testing):**

```bash
# Run interactively
./run.sh
```

## Runner Configuration

### Environment Setup on Runner

Ensure the following tools are installed on your self-hosted runner:

```bash
# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install PowerShell
sudo apt-get install -y powershell

# Install Git
sudo apt-get install -y git

# Install jq (for JSON parsing)
sudo apt-get install -y jq
```

### Runner Labels Configuration

The workflow files reference the following labels:

```yaml
runs-on: [self-hosted, linux]
```

Ensure your runner has at least these labels:
- `self-hosted` (automatic)
- `linux` (added during configuration)

You can add custom labels for filtering:

```bash
# Add labels to existing runner
./config.sh --url https://github.com/Gurkirats08/IaCtesting \
  --token YOUR_GITHUB_TOKEN \
  --name my-self-hosted-runner \
  --labels self-hosted,linux,terraform,azure,prod
```

## Health Checks

### Verify Runner Connectivity

```bash
# Check runner status from repository
# Navigate to Settings → Actions → Runners
# Status should show "Idle" (green) or "Running" (yellow)

# Check runner logs
sudo journalctl -u actions.runner.* -n 50
```

### Test Workflow Execution

1. Go to **Actions** → Select any workflow
2. Click **Run workflow**
3. Select **Plan** action
4. Observe the workflow execution

**Expected behavior:**
- Job should execute on self-hosted runner
- No "Waiting for a runner" message

### Verify Environment Variables

The runner automatically has access to:

```
ACTIONS_ID_TOKEN_REQUEST_TOKEN
ACTIONS_ID_TOKEN_REQUEST_URL
RUNNER_OS
RUNNER_ARCH
RUNNER_NAME
```

## Troubleshooting

### Runner Status: "Offline"

**Symptoms:** Runner shows offline in GitHub UI

**Solutions:**

```bash
# 1. Check if service is running
sudo systemctl status actions.runner.*

# 2. Restart the service
sudo ./svc.sh stop
sudo ./svc.sh start

# 3. Check network connectivity
ping github.com

# 4. Check firewall rules
sudo ufw status
sudo ufw allow 443/tcp

# 5. Review logs
sudo journalctl -u actions.runner.* -n 100
```

### Workflow Fails: "No matching runner found"

**Symptoms:** Workflow fails with "No matching runner found"

**Solutions:**

```bash
# 1. Verify runner labels match workflow
# Check workflow: runs-on: [self-hosted, linux]

# 2. Verify runner is registered
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/Gurkirats08/IaCtesting/actions/runners

# 3. Re-register runner with correct labels
cd ~/actions-runner
./config.sh --url https://github.com/Gurkirats08/IaCtesting \
  --token YOUR_GITHUB_TOKEN \
  --labels self-hosted,linux
```

### Terraform State Lock Timeout

**Symptoms:** "Error acquiring the state lock"

**Solutions:**

```bash
# 1. Check for hung processes
ps aux | grep terraform

# 2. Force unlock state
cd platform-connectivity-alz-deployment/connectivity
terraform force-unlock <LOCK_ID>

# 3. Increase runner resources if needed
sudo nano /etc/systemd/system/actions.runner.*.service
# Add: MemoryLimit=8G
```

### OIDC Authentication Fails

**Symptoms:** "AADSTS error during Azure login"

**Solutions:**

```bash
# 1. Verify Azure credentials
az login --service-principal \
  -u $AZURE_CLIENT_ID \
  -p $AZURE_CLIENT_SECRET \
  --tenant $AZURE_TENANT_ID

# 2. Check federated identity credential
az ad app federated-identity-credential list \
  --id $AZURE_CLIENT_ID

# 3. Verify secrets are set in GitHub
# Settings → Secrets and variables → Actions
# AZURE_CLIENT_ID
# AZURE_TENANT_ID
# AZURE_SUBSCRIPTION_ID
```

### Disk Space Issues

**Symptoms:** "No space left on device"

**Solutions:**

```bash
# Check disk usage
df -h

# Clean up runner workspace
cd ~/actions-runner/_work
rm -rf ./*

# Expand disk or move to larger partition
```

## Security Best Practices

### 1. Network Security

```bash
# Configure firewall
sudo ufw enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 443/tcp   # GitHub outbound
sudo ufw deny incoming   # Deny all other incoming
```

### 2. Access Control

```bash
# Restrict runner access
# Settings → Actions → Runners → [Runner Name] → Details
# Set "Runner group": Private

# Use separate runners for different environments
# Label them appropriately: prod, staging, dev
```

### 3. Secret Management

```bash
# Never hardcode credentials
# Always use GitHub Secrets:
# Settings → Secrets and variables → Actions

# For local testing, use .env files (git-ignored)
```

### 4. Regular Maintenance

```bash
# Update runner version regularly
cd ~/actions-runner
./config.sh --check-for-updates

# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Rotate secrets periodically
```

## Scaling with Multiple Runners

For high-throughput deployments, set up multiple runners:

```bash
# On different machines, repeat the setup process
# Give each runner a unique name:

Runner 1:
./config.sh --url ... --name runner-1 --labels self-hosted,linux,az1

Runner 2:
./config.sh --url ... --name runner-2 --labels self-hosted,linux,az2

Runner 3:
./config.sh --url ... --name runner-3 --labels self-hosted,linux,az3
```

Workflows will automatically distribute across available runners.

## Support & Additional Resources

- [GitHub Self-Hosted Runner Documentation](https://docs.github.com/en/actions/hosting-your-own-runners)
- [GitHub Actions API - List Self-Hosted Runners](https://docs.github.com/en/rest/reference/actions#list-self-hosted-runners-for-a-repository)
- [Actions Runner Source Code](https://github.com/actions/runner)
- [Terraform Troubleshooting Guide](https://learn.hashicorp.com/tutorials/terraform/troubleshooting-workflow)
- [Azure Authentication with OIDC](https://learn.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust-github)
