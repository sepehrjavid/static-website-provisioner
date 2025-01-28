resource "google_compute_global_address" "default" {
  name = "website-ip"
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  name = "website-cert"
  managed {
    domains = [
      for env in var.branches : (
        env == var.default_branch_name ? var.dns_config.domain_name : "${env}.${var.dns_config.domain_name}"
      )
    ]
  }
}

resource "google_compute_backend_bucket" "backends" {
  for_each    = var.branches
  name        = each.key
  bucket_name = var.website_buckets[each.key].name
  enable_cdn  = var.enable_cdn
}

resource "google_compute_url_map" "default" {
  name = "https-lb"

  default_service = var.website_buckets[var.default_branch_name].id

  dynamic "host_rule" {
    for_each = var.branches
    content {
      hosts        = [each.key == var.default_branch_name ? var.dns_config.domain_name : "${env}.${var.dns_config.domain_name}"]
      path_matcher = "${each.key}-matcher"
    }
  }

  dynamic "path_matcher" {
    for_each = var.branches
    content {
      name            = "${each.key}-matcher"
      default_service = google_compute_backend_bucket.backends[each.key].id

      path_rule {
        paths   = ["/*"]
        service = google_compute_backend_bucket.backends[each.key].id
      }
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "https-lb-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "https-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
