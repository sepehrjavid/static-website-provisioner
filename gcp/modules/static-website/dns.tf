# resource "google_dns_record_set" "cname" {
#   name         = google_certificate_manager_dns_authorization.default.dns_resource_record[0].name
#   managed_zone = google_dns_managed_zone.default.name
#   type         = google_certificate_manager_dns_authorization.default.dns_resource_record[0].type
#   ttl          = 300
#   rrdatas      = [google_certificate_manager_dns_authorization.default.dns_resource_record[0].data]
# }
