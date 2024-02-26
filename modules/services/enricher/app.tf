locals {
  service = "gametuner-enricher"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id = local.service
}

resource "google_project_iam_member" "storage_object_viewer" {
  project = var.project
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "monitoring_editor" {
  project = var.project
  role   = "roles/monitoring.editor"
  member = "serviceAccount:${google_service_account.this.email}"
}

module "mig" {
  project = var.project
  source = "../../mig_container"
  service_name = local.service
  region = var.region
  zones = var.zones
  container_env = [
    {
      name = "JAVA_OPTS"
      value = "-Dorg.slf4j.simpleLogger.defaultLogLevel=${lower(var.log_level)}"
    }]
  container_image = var.container_image != null ? var.container_image : local.default_container_image
  machine_type = var.machine_type
  num_instances = var.num_instances
  service_account_email = google_service_account.this.email
  network = var.network_name
  subnetwork = var.subnetwork_name
  container_args = [
    "--config",  base64encode(templatefile(var.config_path, {
      pubsub_collector_good_topic_sub_id = var.pubsub_collector_good_topic_sub_id
      good_topic_id= google_pubsub_topic.good.id
      bad_topic_id = google_pubsub_topic.bad.id
      metadata_ip_address = var.metadata_ip_address
    })),
    "--iglu-config",  base64encode(var.iglu_config),
    "--enrichments",  base64encode(local.enrichments),
    ]
  github_repository = var.github_repository
  alerting_notification_channels = var.alerting_notification_channels
}