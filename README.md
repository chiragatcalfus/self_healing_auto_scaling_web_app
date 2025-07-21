# self_healing_auto_scaling_web_app

This project automates the deployment of a 3 tier app using the helm on kubernetes cluster with one master and 2 worker

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed
- Ansible installed

## Quick Start

1. **Configure AWS**
   ```bash
   aws configure
   ```

2. **Clone and navigate to the repository**
   ```bash
   git clone <repository-url>
   cd self_healing_auto_scaling_web_app
   ```

3. **Set executable permissions**
   ```bash
   chmod +x apply.sh
   chmod +x destroy.sh
   ```
4. **Create a .vault_pass.txt with your ansible-vault password in it'
   ```bash
   vi .vault_pass.txt
   ```

5. **Deploy infrastructure and configure servers**
   ```bash
   ./apply.sh
   ```

6. **Clean up resources**
   ```bash
   ./destroy.sh
   ```

## What it does

- Creates a kubernetes cluster using 3 vms which are IAC configured.
- Automatically runs Ansible playbooks to install and configure frontend-> nginx, backend-> hashicorp/http-echo, hemp installed postgres
- Sets up an environment ready for use and deploy

## Files

- `apply.sh` - Deploys infrastructure and runs configuration
- `destroy.sh` - Tears down all created resources
- Terraform configuration files for EC2 provisioning of t3.xlarge 
- Ansible playbooks for installations and configurations
