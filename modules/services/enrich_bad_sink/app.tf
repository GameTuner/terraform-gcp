locals {
  service = "gametuner-enrich-bad-sink"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id   = local.service
}

resource "google_project_iam_member" "pubsub_subscriber" {
  project = var.project
  role   = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "monitoring_editor" {
  project = var.project
  role   = "roles/monitoring.editor"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "bigquery" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.this.email}"
}

module "mig" {
  project = var.project
  source = "../../mig_container"
  service_name = local.service
  region = var.region
  zones = var.zones
  container_env = [
    {
      name  = "GCP_PROJECT_ID"
      value = var.project
    },
    {
      name = "ENRICH_BAD_SUB"
      value = var.enrich_bad_subscription_name
    },
    {
      name = "BIGQUERY_DATASET"
      value = var.bigquery_dataset_name
    },
    {
      name = "BIGQUERY_TABLE"
      value = var.bigquery_table_name
    }
  ]
  container_image = var.container_image != null ? var.container_image : local.default_container_image
  machine_type = var.machine_type
  num_instances = var.num_instances
  service_account_email = google_service_account.this.email
  network = var.network
  subnetwork = var.subnetwork
  github_repository = var.github_repository
  alerting_notification_channels = var.alerting_notification_channels
}