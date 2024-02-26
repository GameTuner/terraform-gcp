
resource "google_project_service" "compute" {
  project = google_project.this.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = google_project.this.project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "bigquery" {
  project = google_project.this.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "dataflow" {
  project = google_project.this.project_id
  service = "dataflow.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = google_project.this.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "functions" {
  project = google_project.this.project_id
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "sheets" {
  project = google_project.this.project_id
  service = "sheets.googleapis.com"
}

resource "google_project_service" "iam" {
  project = google_project.this.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "composer" {
  project = google_project.this.project_id
  service = "composer.googleapis.com"
}

resource "google_project_service" "cloudscheduler" {
  project = google_project.this.project_id
  service = "cloudscheduler.googleapis.com"
}

resource "google_project_service" "dataproc" {
  project = google_project.this.project_id
  service = "dataproc.googleapis.com"
}

resource "google_project_service" "servicenetworking" {
  project = google_project.this.project_id
  service = "servicenetworking.googleapis.com"
}

resource "google_project_service" "secretmanager" {
  project = google_project.this.project_id
  service = "secretmanager.googleapis.com"
}

resource "google_project_service" "bigqueryconnection" {
  project = google_project.this.project_id
  service = "bigqueryconnection.googleapis.com"
}

resource "google_project_service" "aiplatform" {
  project = google_project.this.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_project_service" "run" {
  project = google_project.this.project_id
  service = "run.googleapis.com"
}