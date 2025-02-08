output "lb_ip" {
  value       = google_compute_global_address.default.address
  description = "IP address to reach the website"
}

output "dns_auth_creds" {
  value = var.dns_config.set_dns_config ? null : {
    for key, auth in google_certificate_manager_dns_authorization.default :
    key => {
      cname  = auth.dns_resource_record[0].name
      type   = auth.dns_resource_record[0].type
      secret = auth.dns_resource_record[0].data
    }
  }
}
