# Infrastructure as Code - DevOps Stack

Automated infrastructure deployment for a production-ready multi-server environment using Infrastructure as Code principles.

## What This Does

This project automatically provisions and configures a complete infrastructure with:
- **2 cloud servers** (Hetzner Cloud)
- **DNS management** (OVH)
- **Self-hosted Git** (Gitea)
- **Secret management** (Infisical)
- **SSL certificates** (Let's Encrypt)
- **Security hardening** (Firewall, Fail2ban, SSH)

All configured with a few commands, repeatable and versioned.

## Architecture Overview

```
┌─────────────────────┐    ┌─────────────────────────────┐
│   Web Server        │    │   Infrastructure Server     │
│   (cx22, fsn1)      │    │   (cx32, nbg1)              │
├─────────────────────┤    ├─────────────────────────────┤
│ • Static Website    │    │ • Gitea (Git hosting)       │
│ • Nginx             │    │ • Infisical (Secrets)       │
│ • SSL/TLS           │    │ • Nginx (reverse proxy)     │
└─────────────────────┘    └─────────────────────────────┘
        │                           │
        ▼                           ▼
  louisemard.dev              git.louisemard.dev
                             vault.louisemard.dev
```

##  Tech Stack

**Infrastructure Layer:**
- Terraform → Provisions cloud resources (servers, DNS)
- Ansible → Configures servers and deploys services

**Application Layer:**
- Docker → Runs isolated services
- Nginx → Web server & reverse proxy
- Certbot → Automatic SSL certificates

**Services:**
- Gitea → Self-hosted Git repositories
- Infisical → Secrets/credentials management

## How It Works

### 1. Infrastructure Provisioning (Terraform)

Terraform reads your configuration and creates:
- 2 servers on Hetzner Cloud
- DNS records pointing to these servers
- Firewall rules
- SSH keys for access

**What happens:**
```
terraform apply
  ↓
Creates servers on Hetzner
  ↓
Configures DNS on OVH
  ↓
Returns server IPs
```

### 2. Configuration Management (Ansible)

Ansible connects to the servers via SSH and:
- Hardens security (firewall, fail2ban, SSH)
- Installs required software (Docker, Nginx)
- Deploys services (Gitea, Infisical)
- Configures SSL certificates

**What happens:**
```
ansible-playbook main.yaml
  ↓
Runs common.yaml → Security setup on all servers
  ↓
Runs web-stack.yaml → Nginx + website on web server
  ↓
Runs infra-stack.yaml → Gitea + Infisical on infra server
```

### 3. Service Deployment (Docker)

Each service runs in isolated Docker containers:

**Gitea:**
```
Docker Compose starts:
  ├── Gitea app (port 3000)
  └── MySQL database
     ↓
Nginx proxies → git.louisemard.dev:443 → localhost:3000
```

**Infisical:**
```
Docker Compose starts:
  ├── Infisical app (port 8080)
  ├── PostgreSQL database
  └── Redis cache
     ↓
Nginx proxies → vault.louisemard.dev:443 → localhost:8080
```

## Project Structure (Simplified)

```
.
├── infra/                  # Terraform (creates servers & DNS)
│   └── envs/dev/
│       ├── main.tf         # Server definitions
│       ├── variables.tf    # Input variables
│       └── secrets.auto.tfvars  # API keys (not committed)
│
├── ansible/                # Ansible (configures servers)
│   ├── inventory/
│   │   └── inventory.ini   # Server IPs
│   ├── playbooks/          # What to do
│   │   ├── main.yaml       # Runs everything
│   │   ├── common.yaml     # Security setup
│   │   ├── web-stack.yaml  # Web server
│   │   ├── gitea.yaml      # Git hosting
│   │   └── infisical.yaml  # Secrets manager
│   └── templates/          # Configuration files
│       ├── docker/         # Docker Compose files
│       └── nginx/          # Nginx configs
│
└── scripts/
    └── secrets.sh          # Generates random passwords
```


---

**Author**: Louis Emard  
**Contact**: contact.louisemard@icloud.com  
**Website**: https://louisemard.dev

*Last Updated: October 2025*