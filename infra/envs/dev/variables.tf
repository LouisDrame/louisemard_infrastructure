# Hetzner variables
variable "hetzner_api_key" {
    type = string
    description = "API key for Hetzner Cloud"
    sensitive = true
}

# Hetzner server configuration variables
variable "server_image" {
    type = string
    description = "Image for all servers"
    default = "ubuntu-24.04"
}

variable servers {
    type = map(object({
        name     = string
        type     = string
        location = string
        labels   = map(string)
    }))
    description = "Map of server configurations"
}

variable "ssh_key_path" {
    type = string
    description = "Path to the SSH public key"
    default = "../../ssh/hetzner/hetzner.pub"
}

# OVH provider credentials
variable "ovh_application_key" {
    type = string
    description = "OVH Application Key"
    sensitive = true
}

variable "ovh_application_secret" {
    type = string
    description = "OVH Application Secret"
    sensitive = true
}

variable "ovh_consumer_key" {
    type = string
    description = "OVH Consumer Key"
    sensitive = true
}

# DNS configuration variables

# Map server to DNS records
variable "dns_service_mapping" {
    type = map(string)
    description = "Mapping of DNS services to server keys"
}

variable "dns_records" {
    type = map(object({
        subdomain      = string
        ttl           = optional(number, 3600)
        create_www_cname = optional(bool, false)
    }))
    description = "Map of DNS records to create"
    default     = {}
}

variable "domain_name" {
    type = string
    description = "The domain name to manage"
}