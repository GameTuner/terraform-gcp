locals {
  service = "gametuner-metadata${var.service_suffix}"
  health_check_path = "/health"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id   = local.service
}

resource "google_project_iam_member" "bigquery" {
  project = var.project
  role   = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "bigquery-data-owner" {
  project = var.project
  role   = "roles/bigquery.dataOwner"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "bigquery-job-user" {
  project = var.project
  role   = "roles/bigquery.jobUser"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "monitoring_editor" {
  project = var.project
  role   = "roles/monitoring.editor"
  member = "serviceAccount:${google_service_account.this.email}"
}

# TODO delete after everything works
resource "google_project_iam_custom_role" "bq_job_role" {
  role_id     = "gametuner.gtClientBqJobUser"
  title       = "BigQuery Job User for Gametuner clients"
  description = "Should be given to all gametuner clients, alongside dataset permissions"
  permissions = [
    "bigquery.config.get",
    "bigquery.jobs.create",
    "resourcemanager.projects.get",
  ]
}

module "mig" {
  project = var.project
  source = "../../mig_container"
  service_name = local.service
  region = var.region
  zones = var.zones
  container_env = [
    {
      name = "GCP_PROJECT_ID"
      value = var.project
    },
    {
      name = "SCHEMA_BUCKET_NAME"
      value = google_storage_bucket.schemas.name
    },
    {
      name = "BIGQUERY_REGION"
      value = var.bigquery_region
    },
    {
      name = "CLOUD_SQL_INSTANCE"
      value = google_sql_database_instance.db.connection_name
    },
  ]
  container_image = var.container_image != null ? var.container_image : local.default_container_image
  http_config = {
    health_check_path = local.health_check_path
    port = var.app_port
  }
  machine_type = var.machine_type
  num_instances = var.num_instances
  service_account_email = google_service_account.this.email
  network = var.network
  subnetwork = var.subnetwork
  github_repository = var.github_repository
  alerting_notification_channels = var.alerting_notification_channels
}