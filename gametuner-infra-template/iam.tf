locals {
  data_viewers = [
  ]

  developers = [
  ]

}

resource "google_project_iam_member" "bigquery-data-viewer" {
  for_each = toset(concat(local.data_viewers, local.developers))
  project  = local.project
  role     = "roles/bigquery.dataViewer"
  member   = each.value
}

resource "google_project_iam_member" "bigquery-job-user" {
  for_each = toset(concat(local.data_viewers, local.developers))
  project  = local.project
  role     = "roles/bigquery.jobUser"
  member   = each.value
}

resource "google_project_iam_member" "bigquery-connection-user" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/bigquery.connectionUser"
  member   = each.value
}

# needed for running/viewing cloudbuild jobs
resource "google_project_iam_member" "cloudbuild-builds-editor" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/cloudbuild.builds.editor"
  member   = each.value
}

# needed for SSH over tunnel
resource "google_project_iam_member" "tunner-accessor" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/iap.tunnelResourceAccessor"
  member   = each.value
}

# needed for ssh. consider finding a stricter role
resource "google_project_iam_member" "instance-admin" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/compute.instanceAdmin"
  member   = each.value
}
resource "google_project_iam_member" "sa-user" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/iam.serviceAccountUser"
  member   = each.value
}

resource "google_project_iam_member" "service-usage-consumer" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/serviceusage.serviceUsageConsumer"
  member   = each.value
}

resource "google_project_iam_member" "viewer" {
  for_each = toset(local.developers)
  project  = local.project
  role     = "roles/viewer"
  member   = each.value
}