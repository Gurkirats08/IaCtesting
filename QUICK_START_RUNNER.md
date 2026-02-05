# Quick Start: Self-Hosted Runner Setup

**Time Required**: 15-20 minutes

## Prerequisites

- Admin access to GitHub repository
- Linux machine (Ubuntu 20.04+)
- Sudo access on Linux machine
- Internet connectivity

## 5-Step Setup

### Step 1: Get GitHub Token (2 minutes)

```bash
# Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
# Click "Generate new token"
# Check: repo, admin:org_hook, workflow
# Copy token and save it
```

### Step 2: Download Runner (3 minutes)

```bash
# On your Linux machine:
mkdir ~/github-runner && cd ~/github-runner

# Download (check latest version on https://github.com/actions/runner/releases)
curl -o actions-runner-linux-x64-2.320.0.tar.gz \
  -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz

# Extract
tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz
```

### Step 3: Configure Runner (3 minutes)

```bash
# Run configuration
./config.sh --url https://github.com/Gurkirats08/IaCtesting \
  --token YOUR_GITHUB_TOKEN \
  --name my-runner-1 \
  --labels self-hosted,linux,terraform,azure

# When prompted, just press Enter to accept defaults
```

**Configuration Summary**:
- **URL**: https://github.com/Gurkirats08/IaCtesting
- **Token**: Your GitHub personal access token
- **Runner name**: my-runner-1 (or custom name)
- **Labels**: self-hosted,linux,terraform,azure
- **Work folder**: _work (default)

### Step 4: Install as Service (2 minutes)

```bash
# Install and start service
sudo ./svc.sh install
sudo ./svc.sh start

# Verify it's running
sudo systemctl status actions.runner.Gurkirats08-IaCtesting*
```

### Step 5: Verify Setup (3 minutes)

1. Go to your GitHub repository
2. Navigate to **Settings** → **Actions** → **Runners**
3. Look for your runner name - should show status **Idle** (green circle)

✅ **Done!** Your self-hosted runner is ready.

## Install Required Tools

```bash
# Update system
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
```

## Test Your Setup

1. Go to **Actions** tab
2. Select any workflow (e.g., "ALZ Connectivity Deployment")
3. Click **Run workflow** → **Plan** → **Run workflow**
4. Watch it execute on your self-hosted runner

You should see:
- ✅ No "Waiting for a runner" message
- ✅ Workflow starts immediately
- ✅ Executes on your runner name

## Common Issues

### Runner shows "Offline"

```bash
# Restart service
sudo ./svc.sh stop
sudo ./svc.sh start

# Check logs
sudo journalctl -u actions.runner.* -n 50
```

### Terraform not found

```bash
# Verify installation
terraform --version

# Add to PATH if needed
which terraform
```

### Permission denied

```bash
# Ensure user can run commands
sudo usermod -aG docker $USER
# Log out and back in
```

## Multiple Runners

To run workflows in parallel, set up multiple runners on different machines. Each should have:

- Unique name: runner-1, runner-2, runner-3, etc.
- Same labels: self-hosted,linux,terraform,azure
- Same GitHub token

## Documentation

- **Full Setup Guide**: [SELF_HOSTED_RUNNER_SETUP.md](SELF_HOSTED_RUNNER_SETUP.md)
- **Migration Summary**: [SELF_HOSTED_RUNNERS_MIGRATION.md](SELF_HOSTED_RUNNERS_MIGRATION.md)
- **GitHub Docs**: https://docs.github.com/en/actions/hosting-your-own-runners

## Support

For issues or questions:

1. Check [SELF_HOSTED_RUNNER_SETUP.md](SELF_HOSTED_RUNNER_SETUP.md#troubleshooting)
2. Review GitHub Actions logs:
   ```bash
   sudo journalctl -u actions.runner.* -f
   ```
3. Verify runner connectivity:
   ```bash
   curl -v https://github.com/actions/
   ```

---

**Need help?** See the [full setup guide](SELF_HOSTED_RUNNER_SETUP.md) for detailed instructions.
