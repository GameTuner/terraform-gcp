locals {
  service = "gametuner-bigquery-loader"

  dataflow_template = "templates/bigquery-loader.json"
  dataflow_temp = "/temp"
  default_container_image = "${var.region}-docker.pkg.dev/${var.project}/gametuner_pipeline_services/${local.service}:latest"
}

resource "google_service_account" "this" {
  account_id = local.service
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_bucket" "dataflow" {
  project = var.project
  name          = "${var.project}-dataflow"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket_object" "template" {
  name   = local.dataflow_template
  content = <<EOF
  {
    "defaultEnvironment": {
        "enableStreamingEngine": true
    },
    "image": "${var.container_image != null ? var.container_image : local.default_container_image}",

    "sdkInfo": {
        "language": "JAVA"
    }
}
EOF
  bucket = google_storage_bucket.dataflow.name
}

resource "random_id" "big_data_job_name_suffix" {
  byte_length = 4
  keepers = {
    region  = var.region
    service = local.service
  }
}
resource "google_dataflow_flex_template_job" "this" {
  provider                      = google-beta

  # we take hash so job gets replaced when image digest changed
  name                          = "${local.service}-${random_id.big_data_job_name_suffix.dec}"
  region                        = var.region
  container_spec_gcs_path       = "gs://${google_storage_bucket.dataflow.name}/${google_storage_bucket_object.template.name}"
  on_delete = "drain"
  parameters = {
    project = var.project
    region = var.region
    runner="dataflow"
    network=var.network
    subnetwork=var.subnetwork_url
    serviceAccountEmail = google_service_account.this.email
    gcpTempLocation = "gs://${google_storage_bucket.dataflow.name}${local.dataflow_temp}"
    jobName = local.service
    numWorkers = var.num_instances
    maxNumWorkers = var.num_instances
    machineType = var.machine_type
    diskSizeGb=10
    config = base64encode(templatefile(var.config_path, {
      gcp_project_id = var.project
      pubsub_enricher_good_topic_sub_name = var.pubsub_enricher_good_topic_sub_name
      bad_topic = google_pubsub_topic.bad.name
      failed_inserts_topic = google_pubsub_topic.failed_inserts.name
    })),
    resolver = base64encode(var.iglu_config)
  }

  #this is workaround because terraform doesn't support waiting for cloud build trigger
  depends_on = [time_sleep.wait_image_build]
}

resource "google_cloudbuildv2_repository" "this" {
  provider = google-beta
  project = var.project
  location = var.region
  name = var.github_repository.repository_name
  parent_connection = var.github_repository.cloudbuild_repository_connection_name
  remote_uri = var.github_repository.repository_url
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
}

// This is a workaround for the fact that Terraform doesn't support
// triggering Cloud Build builds from a Cloud Build trigger.
// This is needed for first time deployment of the bigquery loader.
resource "null_resource" "run_gcloud" {
  provisioner "local-exec" {
    command = "gcloud builds triggers run ${google_cloudbuild_trigger.manual-trigger.name} --region=${var.region} --branch=main"
  }
  depends_on = [google_cloudbuild_trigger.manual-trigger]
}

resource "time_sleep" "wait_image_build" {
  depends_on = [null_resource.run_gcloud]

  create_duration = "600s"
}