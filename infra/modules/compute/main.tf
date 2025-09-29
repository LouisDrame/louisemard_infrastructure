terraform {
    required_providers {
        hetzner = {
            source  = "hetznercloud/hcloud"
            version = "1.52.0"
        }
    }
}

# TODO : create ssh module
resource "hcloud_ssh_key" "main" {
    name       = "main-ssh-key"
    public_key = file(var.ssh_key_path)
}

# Create firewall to allow only necessary traffic
# TODO : create firewall module, will be reused for other servers
resource "hcloud_firewall" "main" {
    name = "main-firewall"
    # SSH
    rule {
        direction  = "in"
        source_ips = ["0.0.0.0/0"]
        protocol   = "tcp"
        port       = "22"
    }
    # HTTP
    rule {
        direction  = "in"
        source_ips = ["0.0.0.0/0"]
        protocol   = "tcp"
        port       = "80"
    }
    # HTTPS
    rule {
        direction  = "in"
        source_ips = ["0.0.0.0/0"]
        protocol   = "tcp"
        port       = "443"
    }
}

resource "hcloud_server" "servers" {
    for_each = var.servers
    
    name        = each.value.name
    image       = var.server_image # For consistency across all servers
    server_type = each.value.type
    location    = each.value.location
    ssh_keys    = [hcloud_ssh_key.main.id]

    # Labels shown in the Hetzner Cloud Console
    labels = merge(each.value.labels, {
        "managed_by" = "terraform"
    })
}

# Attach the firewall to each server
resource "hcloud_firewall_attachment" "firewall" {
    for_each = var.servers

    server_ids   = [hcloud_server.servers[each.key].id]
    firewall_id = hcloud_firewall.main.id
}
