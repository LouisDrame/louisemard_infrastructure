output "dns_records" {
    description = "Created DNS records"
    value = {
        for key, record in ovh_domain_zone_record.a_records : key => {
            fqdn = record.subdomain == "" ? var.domain_name : "${record.subdomain}.${var.domain_name}"
            ip   = record.target
        }
    }
}

output "www_cnames" {
    description = "Created www CNAME records"
    value = {
        for key, record in ovh_domain_zone_record.www_cname : key => {
            fqdn   = "${record.subdomain}.${var.domain_name}"
            target = record.target
        }
    }
}