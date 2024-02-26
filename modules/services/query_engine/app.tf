locals {
  service                 = "gametuner-query-engine${var.service_suffix}"
  health_check_path       = "/health"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id = local.service
}

resource "google_project_iam_member" "bigquery" {
  project = var.project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.this.email}"
}

module "mig" {
  project      = var.project
  source       = "../../mig_container"
  service_name = local.service
  region       = var.region
  zones        = var.zones
  container_env = [
    {
      name  = "GCP_PROJECT_ID"
      value = var.project
    },
    {
      name  = "UVICORN_PORT"
      value = var.app_port
    },
    {
      name  = "METADATA_IP_ADDRESS"
      value = var.metadata_ip_address
    },
    {
      name  = "WEB_CONCURRENCY"
      value = var.num_uvicorn_processes
    },
    {
      name  = "SERVICE_SUFFIX"
      value = var.service_suffix
    },

  ]
  container_image = var.container_image != null ? var.container_image : local.default_container_image
  http_config = {
    health_check_path = local.health_check_path
    port              = var.app_port
  }
  machine_type          = var.machine_type
  num_instances         = var.num_instances
  service_account_email = google_service_account.this.email
  network               = var.network
  subnetwork            = var.subnetwork
  github_repository     = var.github_repository
  alerting_notification_channels = var.alerting_notification_channels
}