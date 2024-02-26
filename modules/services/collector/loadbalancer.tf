resource "google_compute_url_map" "this" {
  name            = "${local.service}-glb"
  default_service = google_compute_backend_service.this.id

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_compute_health_check" "this" {
  name     = "${local.service}-glb-hc"
  provider = google-beta
  http_health_check {
    request_path = local.health_check_path
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_backend_service" "this" {
  name = "${local.service}-glb-backend"
  protocol         = "HTTP"
  timeout_sec      = 60
  session_affinity = "NONE"
  connection_draining_timeout_sec = 30

  backend {
    group           = module.mig.instance_group
  }
  health_checks         = [google_compute_health_check.this.id]
}

resource "google_compute_global_address" "this" {
  name                  = "${local.service}-glb-ip"

  # lifecycle {
  #   prevent_destroy = true
  # }
}
