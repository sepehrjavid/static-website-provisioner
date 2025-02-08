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
  bucket_name = google_storage_bucket.website_bucket[each.key].name
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

##############################
##    Redirect Resources    ##
##############################

resource "google_compute_url_map" "http_redirect_url_map" {
  count = var.enable_http_redirect ? 1 : 0
  name  = "http-redirect-lb"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "http_redirect_proxy" {
  count   = var.enable_http_redirect ? 1 : 0
  name    = "https-redirect-proxy"
  url_map = google_compute_url_map.http_redirect_url_map[0].id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  count                 = var.enable_http_redirect ? 1 : 0
  name                  = "http-redirect-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.http_redirect_proxy[0].id
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.default.address
}
