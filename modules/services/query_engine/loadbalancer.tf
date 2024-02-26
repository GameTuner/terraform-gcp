resource "google_compute_forwarding_rule" "this" {
  name                  = "${local.service}-ilb-frontend"
  provider              = google-beta
  region                = var.region
  depends_on            = [var.proxy_subnetwork]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = var.loadbalancer_port
  target                = google_compute_region_target_http_proxy.this.id
  network               = var.network
  subnetwork            = var.subnetwork
  network_tier          = "PREMIUM"
  labels = {
    service = local.service
  }
}

resource "google_compute_region_target_http_proxy" "this" {
  name     = "${local.service}-ilb-proxy"
  provider = google-beta
  region   = var.region
  url_map  = google_compute_region_url_map.this.id
}

resource "google_compute_region_url_map" "this" {
  name            = "${local.service}-ilb"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.this.id
}

resource "google_compute_region_health_check" "this" {
  name     = "${local.service}-ilb-hc"
  provider = google-beta
  region   = var.region
  http_health_check {
    request_path       = local.health_check_path
    port_specification = "USE_SERVING_PORT"
  }
  unhealthy_threshold = 10
  check_interval_sec = 30
}

resource "google_compute_region_backend_service" "this" {
  name                  = "${local.service}-ilb-backend"
  provider              = google-beta
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 300
  health_checks         = [google_compute_region_health_check.this.id]
  connection_draining_timeout_sec = 30
  backend {
    group           = module.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  session_affinity   = "HEADER_FIELD"
  locality_lb_policy = "RING_HASH"
  consistent_hash {
    http_header_name = "APP_ID" # TODO dokumentuj ovo
  }
}