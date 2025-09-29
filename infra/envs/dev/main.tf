terraform {
    required_providers {
        hetzner = {
            source  = "hetznercloud/hcloud"
            version = "1.52.0"
        }
        ovh = {
            source  = "ovh/ovh"
            version = "2.8.0"
        }
    }
}

provider "hcloud" {
    token = var.hetzner_api_key
}
provider "ovh" {
    endpoint    = "ovh-ca"
    application_secret = var.ovh_application_secret
    application_key    = var.ovh_application_key
    consumer_key       = var.ovh_consumer_key
}

locals {
    dns_records_with_ips = {
        for service, config in var.dns_records : service => merge(config, {
            server_ip = module.compute.servers[ var.dns_service_mapping[service] ].ipv4_address
        })
    }
}

module "compute" {
    source = "../../modules/compute"
    
    # Pass server configuration variables to the module
    servers         = var.servers
    # We keep the same image for all servers for consistency
    server_image    = var.server_image
    # Path to the SSH public key
    ssh_key_path    = var.ssh_key_path
}

module "dns" {
    source = "../../modules/dns"
    
    # DNS configuration
    domain_name = var.domain_name
    dns_records = local.dns_records_with_ips
    # Ensure DNS is created after server
    depends_on = [module.compute]
}