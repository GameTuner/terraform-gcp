resource "google_service_account" "cloudbuild" {
  project    = google_project.this.project_id
  account_id = "cloudbuild"
}

resource "google_project_iam_member" "cloudbuild" {
  project = google_project.this.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}