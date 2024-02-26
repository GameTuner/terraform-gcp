resource "google_folder" "main" {
  display_name = var.project_name
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "this" {
  name                = var.project_name
  project_id          = var.project_id
  billing_account     = var.billing_account
  auto_create_network = false
  folder_id           = google_folder.main.id

  lifecycle {
    prevent_destroy = true
  }
}