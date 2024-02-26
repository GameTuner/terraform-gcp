resource "google_project_iam_member" "pull_images" {
  project = var.project
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "logging" {
  project = var.project
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "cloud_tracing" {
  project = var.project
  role   = "roles/cloudtrace.agent"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "error_reporting" {
  project = var.project
  role   = "roles/errorreporting.writer"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${var.service_account_email}"
}