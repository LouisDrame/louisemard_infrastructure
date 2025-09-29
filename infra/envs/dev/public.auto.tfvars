server_image = "ubuntu-24.04"

servers = {
    web = {
        name     = "web"
        type     = "cx22"
        location = "fsn1"
        labels   = {
            "env" = "dev"
            "role" = "web"
        }
    }
    infra = {
        name     = "infra"
        type     = "cx32"
        location = "nbg1"
        labels   = {
            "env" = "dev",
            "role" = "infrastructure"
        }
    }
}

ssh_key_path = "../../ssh/hetzner/hetzner.pub"

# DNS configuration
dns_records = {
    main = {
        subdomain      = ""  # Root domain
        ttl           = 3600
        create_www_cname = true
    }
    gitea = {
        subdomain      = "git"
        ttl           = 3600
        create_www_cname = true
    }
    infisical = {
        subdomain      = "vault"
        ttl           = 3600
        create_www_cname = true
    }
}

dns_service_mapping = {
    main = "web"
    gitea = "infra"
    infisical = "infra"
}
domain_name = "louisemard.dev"
dns_ttl = 3600
create_www_cname = false