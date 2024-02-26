locals {
  service = "gametuner-composer-etl"
}

data "google_project" "this" {
  project_id = var.project
}

resource "google_project_iam_member" "composer_agent" {
  project = data.google_project.this.project_id
  role    = "roles/composer.ServiceAgentV2Ext"
  member  = format("serviceAccount:%s",
    format("service-%s@cloudcomposer-accounts.iam.gserviceaccount.com", data.google_project.this.number))
}

resource "google_service_account" "this" {
  account_id = local.service
}

resource "google_project_iam_member" "bigquery" {
  project = var.project
  role   = "roles/bigquery.admin"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "composer_worker" {
  project = var.project
  role   = "roles/composer.worker"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "dataproc_editor" {
  project = var.project
  role   = "roles/dataproc.editor"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "dataproc_worker" {
  project = var.project
  role   = "roles/dataproc.worker"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "aiplatform_user" {
  project = var.project
  role   = "roles/aiplatform.user"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_composer_environment" "etl" {
  name   = local.service
  region = var.region
  project = var.project
  config {
    software_config {
      image_version = "composer-2-airflow-2"
      pypi_packages = var.pypi_packages

      env_variables = {
        GCP_PROJECT_ID = var.project
        AIRFLOW_DEFAULT_SERVICE_ACCOUNT = google_service_account.this.email
        BQ_DATASETS_LOCATION = var.bq_datasets_location
        APPSFLYER_DATA_LOCKER_BUCKET_NAME = google_storage_bucket.appsflyer_data_locker.name
        APPSFLYER_BIGQUERY_PROJECT_ID = var.project
        APPSFLYER_DATAPROC_BUCKET_NAME = google_storage_bucket.dataproc_service.name
        APPSFLYER_DATAPROC_EXECUTION_REGION =  var.region
        APPSFLYER_DATAPROC_EXECUTION_PROJECT_ID = var.project
        APPSFLYER_DATAPROC_SUBNETWORK_NAME = var.subnetwork_url
        METADATA_IP_ADDRESS = var.metadata_ip_address
        MAXMIND_BUCKET=var.maxmind_bucket
        MAXMIND_LICENCE_KEY=var.maxmind_licence_key
        SLACK_WEBHOOK_URL=var.slack_webhook_url
        CURRENCY_API_KEY=var.currency_api_key
        UNIQUE_ID_BQ_CONNECTION=format("%s.%s", lower(google_bigquery_connection.connection.location), google_bigquery_connection.connection.connection_id)
      }
    }

    node_config {
      service_account = google_service_account.this.email
      network = var.network_url
      subnetwork = var.subnetwork_url
    }

    workloads_config {
      scheduler {
        cpu        = 2
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 3
        storage_gb = 1
      }
      worker {
        cpu = 2
        memory_gb  = 6
        storage_gb = 1
        min_count  = 2
        max_count  = 2
      }
    }
  }

  depends_on = [google_project_iam_member.composer_agent]

  lifecycle {
    ignore_changes = [ 
      config.0.software_config.0.env_variables["COMPOSER_ENVIRONMENT_URL"],
    ]
  }
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

  depends_on = [google_composer_environment.etl]
}

// This is a workaround for the fact that Terraform doesn't support
// triggering Cloud Build builds from a Cloud Build trigger.
// This is needed for first time deployment of the Composer environment.
resource "null_resource" "run_gcloud" {
  provisioner "local-exec" {
    command = "gcloud builds triggers run ${google_cloudbuild_trigger.manual-trigger.name} --region=${var.region} --branch=main"
  }
  depends_on = [google_cloudbuild_trigger.manual-trigger]
}