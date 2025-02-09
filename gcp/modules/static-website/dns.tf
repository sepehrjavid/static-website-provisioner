resource "google_dns_record_set" "cert_auth" {
  for_each     = var.dns_config.set_dns_config ? var.branches : []
  name         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].name
  managed_zone = var.dns_config.zone_name
  type         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].data]
}

resource "google_dns_record_set" "website_ip_record" {
  name         = "${var.dns_config.domain_name}."
  managed_zone = var.dns_config.zone_name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.default.address]
}

resource "google_dns_record_set" "website_dub_domanins" {
  for_each     = { for branch in var.branches : branch => branch if branch != var.default_branch_name }
  name         = "${each.key}.${var.dns_config.domain_name}."
  managed_zone = var.dns_config.zone_name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${var.dns_config.domain_name}."]
}

