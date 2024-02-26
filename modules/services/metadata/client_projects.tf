data "google_project" "this" {
  project_id = var.project
}

resource "google_folder" "client_projects" {
  display_name = "Client Projects"
  parent       = "folders/${data.google_project.this.folder_id}"
}

resource "google_project" "client_projects" {
  for_each            = { for index, client in var.client_projects : index => client }
  project_id          = each.value.project_id
  name                = each.value.project_display_name
  billing_account     = var.billing_account
  auto_create_network = false
  folder_id           = google_folder.client_projects.id

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_project_service" "bigquerystorage" {
  for_each                   = { for index, client in var.client_projects : index => client }
  project                    = each.value.project_id
  service                    = "bigquerystorage.googleapis.com"
  disable_dependent_services = true
  depends_on                 = [google_project.client_projects]
}

resource "google_project_service" "bigquery" {
  for_each            = { for index, client in var.client_projects : index => client }
  project = each.value.project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services = true
  depends_on = [google_project.client_projects]
}

resource "google_project_iam_custom_role" "clientAdmin" {
  for_each            = { for index, client in var.client_projects : index => client }
  role_id     = "gametuner.clientAdmin"
  project = each.value.project_id
  title       = "Gametuner Client Admin"
  description = "Max permissions given to gametuner clients on their projects"
  permissions = [
    "bigquery.config.get",
    "bigquery.datasets.create",
    "bigquery.datasets.get",
    "bigquery.datasets.getIamPolicy",
    "bigquery.datasets.updateTag",
    "bigquery.models.create",
    "bigquery.models.delete",
    "bigquery.models.export",
    "bigquery.models.getData",
    "bigquery.models.getMetadata",
    "bigquery.models.list",
    "bigquery.models.updateData",
    "bigquery.models.updateMetadata",
    "bigquery.models.updateTag",
    "bigquery.routines.create",
    "bigquery.routines.delete",
    "bigquery.routines.get",
    "bigquery.routines.list",
    "bigquery.routines.update",
    "bigquery.routines.updateTag",
    "bigquery.tables.export",
    "bigquery.tables.get",
    "bigquery.tables.getData",
    "bigquery.tables.getIamPolicy",
    "bigquery.tables.list",
    "bigquery.tables.replicateData",
    "bigquery.tables.restoreSnapshot",
    "resourcemanager.projects.get",
    "bigquery.config.get",
    "bigquery.jobs.create",
    "bigquery.transfers.get",
    "bigquery.transfers.update",
  ]
  depends_on = [google_project.client_projects]
}

resource "google_folder_iam_member" "project_iam_admin" {
  folder  = google_folder.client_projects.id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.this.email}"
}

resource "google_folder_iam_member" "bigquery_editor" {
  folder  = google_folder.client_projects.id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.this.email}"
}