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

  default_service = google_compute_backend_bucket.backends[var.default_branch_name].id

  dynamic "host_rule" {
    for_each = var.branches
    content {
      hosts        = [host_rule.value == var.default_branch_name ? var.dns_config.domain_name : "${host_rule.value}.${var.dns_config.domain_name}"]
      path_matcher = "${host_rule.value}-matcher"
    }
  }

  dynamic "path_matcher" {
    for_each = var.branches
    content {
      name            = "${path_matcher.value}-matcher"
      default_service = google_compute_backend_bucket.backends[path_matcher.value].id

      path_rule {
        paths   = ["/*"]
        service = google_compute_backend_bucket.backends[path_matcher.value].id
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
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
