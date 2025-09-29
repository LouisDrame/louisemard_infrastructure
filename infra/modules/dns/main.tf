terraform {
    required_providers {
        ovh = {
            source  = "ovh/ovh"
            version = "2.8.0"
        }
    }
}

# DNS A record for the domain
resource "ovh_domain_zone_record" "a_records" {
    for_each = var.dns_records

    # This module only works for a single domain, so we don't need to pass it in the map
    zone      = var.domain_name
    subdomain = each.value.subdomain
    fieldtype = "A"
    ttl       = each.value.ttl
    target    = each.value.server_ip
}

# Optional: CNAME record for www
resource "ovh_domain_zone_record" "www_cname" {
    for_each = {
        for key, record in var.dns_records : key => record
        if record.create_www_cname == true
    }
    zone      = var.domain_name
    subdomain = each.value.subdomain == "" ? "www" : "www.${each.value.subdomain}"
    fieldtype = "CNAME"
    ttl       = each.value.ttl
    target    = each.value.subdomain == "" ? "${var.domain_name}." : "${each.value.subdomain}.${var.domain_name}."
}

# Refresh the zone after changes
# resource "ovh_domain_zone_record_set" "refresh" {
#     zone = var.domain_name
    
#     depends_on = [
#         ovh_domain_zone_record.main_a_record,
#         ovh_domain_zone_record.www_cname
#     ]
# }