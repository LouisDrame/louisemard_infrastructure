# Outputs pour la nouvelle structure avec for_each
output "servers" {
    description = "Map of all created servers with their details"
    value = {
        for key, server in hcloud_server.servers : key => {
            id           = server.id
            name         = server.name
            ipv4_address = server.ipv4_address
            ipv6_address = server.ipv6_address
            status       = server.status
            server_type  = server.server_type
            location     = server.location
        }
    }
}

# Outputs des ressources partagées
output "ssh_key_id" {
    description = "ID of the created SSH key"
    value       = hcloud_ssh_key.main.id
}

output "firewall_id" {
    description = "ID of the created firewall"
    value       = hcloud_firewall.main.id
}

# Outputs backwards compatibility (pour ne pas casser l'existant)
output "ipv4_address" {
    description = "IP address of the main server (backwards compatibility)"
    value       = try(hcloud_server.servers["web"].ipv4_address, "")
}

output "server_id" {
    description = "ID of the main server (backwards compatibility)"
    value       = try(hcloud_server.servers["web"].id, "")
}

# Outputs spécifiques par type de serveur
output "web_server_ip" {
    description = "IP address of the web server"
    value       = try(hcloud_server.servers["web"].ipv4_address, null)
}

output "infra_server_ip" {
    description = "IP address of the infrastructure server"
    value       = try(hcloud_server.servers["infra"].ipv4_address, null)
}

# Output pour l'inventaire Ansible
output "ansible_inventory" {
    description = "Server details formatted for Ansible inventory"
    value = {
        for key, server in hcloud_server.servers : key => {
            ansible_host = server.ipv4_address
            ansible_user = "root"
            server_name  = server.name
            server_role  = server.labels["role"]
        }
    }
}

# Output de tous les IPs pour référence facile
output "all_ips" {
    description = "All server IP addresses"
    value = {
        for key, server in hcloud_server.servers : key => server.ipv4_address
    }
}