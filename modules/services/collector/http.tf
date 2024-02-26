resource "google_compute_global_forwarding_rule" "http" {
  count = var.ssl_config == null ? 1 : 0
  name                  = "${local.service}-glb-http-frontend"
  target                = google_compute_target_http_proxy.http[0].id
  port_range            = 80
  ip_address = google_compute_global_address.this.address
  labels = {
    service = local.service
  }
}

resource "google_compute_target_http_proxy" "http" {
  count = var.ssl_config == null ? 1 : 0
  name     = "${local.service}-glb-http-proxy"
  url_map  = google_compute_url_map.this.id
}