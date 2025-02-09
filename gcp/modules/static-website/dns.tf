resource "google_dns_record_set" "cname" {
  for_each     = var.dns_config.set_dns_config ? var.branches : []
  name         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].name
  managed_zone = var.dns_config.zone_name
  type         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].data]
}
