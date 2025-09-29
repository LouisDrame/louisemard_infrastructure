# Infrastructure as Code - DevOps Stack

## 🏗️ Architecture

```
┌─────────────────────┐    ┌─────────────────────────────┐
│   Serveur Web       │    │      Serveur Infra         │
│   (cx22, fsn1)      │    │      (cx32, nbg1)          │
├─────────────────────┤    ├─────────────────────────────┤
│ • Site web          │    │ • Gitea (Docker)            │
│ • Nginx             │    │ • Infisical (Docker)        │
│ • SSL/TLS           │    │ • Nginx (reverse proxy)    │
└─────────────────────┘    └─────────────────────────────┘
        │                           │
        ▼                           ▼
  louisemard.dev              git.louisemard.dev
  www.louisemard.dev         vault.louisemard.dev
```

## 🚀 Déploiement

### Prérequis
- Terraform/OpenTofu
- Ansible
- Clés API Hetzner et OVH

### 1. Infrastructure (Terraform)
```bash
cd infra/envs/dev
terraform init
terraform plan
terraform apply
```

### 2. Configuration (Ansible)
```bash
cd ansible
ansible-playbook -i inventory/inventory.ini playbooks/main.yaml
```

## 📁 Structure

```
├── infra/                  # Infrastructure Terraform
│   ├── modules/
│   │   ├── compute/        # Serveurs Hetzner
│   │   └── dns/           # DNS OVH
│   └── envs/dev/          # Environnement dev
├── ansible/               # Configuration Ansible
│   ├── inventory/
│   ├── playbooks/
│   │   ├── common.yaml    # Setup commun
│   │   ├── web-stack.yaml # Serveur web
│   │   └── infra-stack.yaml # Serveur infra
│   └── templates/
└── statics/              # Contenu web statique
```

## 🔐 Secrets

Les secrets sont dans `secrets.auto.tfvars` (non commité).
Template dans `secrets.auto.tfvars.example`.

## 🌐 Services

- **Site web**: https://louisemard.dev
- **Gitea**: https://git.louisemard.dev (à venir)
- **Infisical**: https://vault.louisemard.dev (à venir)