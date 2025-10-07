# Gitea secrets
export GITEA_DB_PASSWORD=$(openssl rand -base64 32)
export GITEA_DB_ROOT_PASSWORD=$(openssl rand -base64 32)

echo "Secrets générés:"
echo "GITEA_DB_PASSWORD=${GITEA_DB_PASSWORD}"
echo "GITEA_DB_ROOT_PASSWORD=${GITEA_DB_ROOT_PASSWORD}"


# Write variables to secrets file
cat > secrets/gitea_secrets.env << EOF
GITEA_DB_PASSWORD=${GITEA_DB_PASSWORD}
GITEA_DB_ROOT_PASSWORD=${GITEA_DB_ROOT_PASSWORD}
EOF