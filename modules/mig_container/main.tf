resource "google_compute_health_check" "this" {
  count = var.http_config != null ? 1 : 0
  name    = "${var.service_name}-mig-hc"

  http_health_check {
      request_path = var.http_config.health_check_path
      port         = var.http_config.port
  }

  unhealthy_threshold = 10
  check_interval_sec = 30
}

resource "google_compute_region_instance_group_manager" "this" {
  provider = google-beta

  name                      = "${var.service_name}-mig"
  base_instance_name        = var.service_name
  region                    = var.region
  distribution_policy_zones = var.zones

  update_policy {
    minimal_action = "REPLACE"
    type           = "PROACTIVE"
    max_surge_fixed = length(var.zones)
    max_unavailable_fixed = 0
  }

  version {
    name = "main"
    instance_template = google_compute_instance_template.this.self_link
  }

  all_instances_config {
    labels = {
      service   = var.service_name
    }
  }

  target_size  = var.num_instances

  dynamic "named_port" {
    for_each = var.http_config != null ? [0] : []

    content {
      name = "http"
      port         = var.http_config.port
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.http_config != null ? [0] : []
    content {
      health_check      = google_compute_health_check.this[0].id
      initial_delay_sec = 360
    }
  }

  lifecycle {
    ignore_changes = [
      version[0].name
    ]
  }

}

module "container_vm" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = var.container_image
    env   = var.container_env
    volumeMounts = var.config_dir != null ? [{
      mountPath = var.config_dir
      name      = "config"
      readOnly  = true
    }] : []
    args = var.container_args
  }

  volumes = var.config_dir != null ? [
    {
      name = "config"
      hostPath = {
        path = var.config_dir
      }
    }
  ] : []
}

resource "google_compute_instance_template" "this" {
  name_prefix             = "${var.service_name}-tmpl-"
  project                 = var.project
  machine_type            = var.machine_type
  metadata_startup_script = var.startup_script
  region                  = var.region

  disk {
    disk_size_gb = 10
    source_image         = "cos-cloud/cos-stable-101-17162-127-33"
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
  }

  metadata = {
    "gce-container-declaration" = module.container_vm.metadata_value
  }
  labels = {
    "container-vm" = "cos-stable-101-17162-127-33"
  }

  lifecycle {
    create_before_destroy = "true"
  }
}

resource "google_cloudbuildv2_repository" "this" {
  provider            = google-beta
  project             = var.project
  location            = var.region
  name                = var.github_repository.repository_name
  parent_connection   = var.github_repository.cloudbuild_repository_connection_name
  remote_uri          = var.github_repository.repository_url
}

resource "google_cloudbuild_trigger" "manual-trigger" {
  project     = var.project
  name        = "${google_cloudbuildv2_repository.this.name}-manual-trigger"
  location    = var.region
  service_account = "projects/${var.project}/serviceAccounts/cloudbuild@${var.project}.iam.gserviceaccount.com"

  source_to_build {
    repository = google_cloudbuildv2_repository.this.id
    ref = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = var.github_repository.repository_url
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
  }

  // If this is set on a build, it will become pending when it is run, 
  // and will need to be explicitly approved to start.
  approval_config {
     approval_required = false 
  }

  depends_on = [google_compute_region_instance_group_manager.this]
}

// This is a workaround for the fact that Terraform doesn't support
// triggering Cloud Build builds from a Cloud Build trigger.
// This is needed for first time deployment of the VM.
resource "null_resource" "run_gcloud" {
  provisioner "local-exec" {
    command = "gcloud builds triggers run ${google_cloudbuild_trigger.manual-trigger.name} --region=${var.region} --branch=main"
  }
  depends_on = [google_cloudbuild_trigger.manual-trigger]
}