locals {
  service = "gametuner-collector"
  config_dir = "/etc/${local.service}"
  config_file_path = "${local.config_dir}/config.hocon"
  health_check_path = "/health"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id = local.service

  # lifecycle {
  #   prevent_destroy = true
  # }
}

module "mig" {
  project = var.project
  source = "../../mig_container"
  service_name = local.service
  region = var.region
  zones = var.zones
  container_env = []
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
  config_dir = local.config_dir
  startup_script = templatefile("${path.module}/templates/startup.sh.tmpl", {
      config_dir = local.config_dir
      config_file_path = local.config_file_path
      config = templatefile(var.config_path, {
        port   = var.app_port
        good_topic = var.pubsub_good_topic
        bad_topic = var.pubsub_bad_topic
        gcp_project_id = var.project
      })
    })
  container_args = ["--config", local.config_file_path]
  github_repository = var.github_repository
  alerting_notification_channels = var.alerting_notification_channels
}