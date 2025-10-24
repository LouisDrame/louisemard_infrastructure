#!/bin/sh
set -e

echo "Deploying Gitea"
echo "===================="
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if secrets file exists
if [ ! -f "$SCRIPT_DIR/../secrets/gitea_secrets.env" ]; then
    echo "File secrets/gitea_secrets.env not found"
    echo ""
    echo "First generate the secrets with:"
    echo "   ./scripts/gitea_secrets.sh"
    exit 1
fi

# Load environment variables
echo "Loading environment variables..."
export $(cat "$SCRIPT_DIR/../secrets/gitea_secrets.env" | grep -v '^#' | grep -v '^$' | xargs)

# Check required variables
echo "✓ Vérification des variables..."
if ! "$SCRIPT_DIR/check_env.sh" \
    GITEA_DB_PASSWORD \
    GITEA_DB_ROOT_PASSWORD \
    GITEA_SMTP_HOST \
    GITEA_SMTP_PORT \
    GITEA_SMTP_USER \
    GITEA_SMTP_PASSWORD \
    GITEA_SMTP_FROM; then
    echo ""
    echo "Edit secrets/gitea_secrets.env with your SMTP credentials"
    exit 1
fi

cd "$SCRIPT_DIR/../ansible"
ansible-playbook -i inventory/inventory.ini playbooks/gitea.yaml