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
