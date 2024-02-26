resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = var.repository_id
  project       = var.project
  format        = "DOCKER"
}