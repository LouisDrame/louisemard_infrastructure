variable "dns_records" {
    type = map(object({
        subdomain      = string
        server_ip     = string
        ttl           = optional(number, 3600)
        create_www_cname = optional(bool, false)
    }))
}

variable "domain_name" {
    type = string
    description = "The domain name to manage"
}