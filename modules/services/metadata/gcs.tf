resource "google_storage_bucket" "schemas" {
  project = var.project
  name          = "${var.project}-${local.service}-schemas"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "schemas_writer" {
  bucket = google_storage_bucket.schemas.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_bucket_iam_member" "schemas_reader" {
  bucket = google_storage_bucket.schemas.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}