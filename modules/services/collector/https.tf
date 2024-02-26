resource "google_compute_managed_ssl_certificate" "https" {
  count = var.ssl_config != null ? 1 : 0
  name = "${local.service}-glb-https-cert"

  managed {
    domains = var.ssl_config.domains
  }
}

resource "google_compute_target_https_proxy" "https" {
  count = var.ssl_config != null ? 1 : 0
  name             = "${local.service}-glb-https-proxy"
  url_map          = google_compute_url_map.this.id
  ssl_certificates = [google_compute_managed_ssl_certificate.https[0].id]
}

resource "google_compute_global_forwarding_rule" "https" {
  count = var.ssl_config != null ? 1 : 0
  name                  = "${local.service}-glb-https-frontend"
  target                = google_compute_target_https_proxy.https[0].id
  port_range            = 443
  ip_address            = google_compute_global_address.this.address
  labels = {
    service = local.service
  }
}