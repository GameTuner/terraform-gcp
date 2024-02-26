resource "google_secret_manager_secret" "github-token-secret" {
  project =  var.project
  secret_id = var.github_token_secret_id
  provider = google-beta

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "github-token-secret-version" {
  secret = google_secret_manager_secret.github-token-secret.id
  secret_data = var.github_token_secret_value
}

data "google_project" "this" {
  project_id = var.project
}

data "google_iam_policy" "serviceagent-secretAccessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${data.google_project.this.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project = google_secret_manager_secret.github-token-secret.project
  secret_id = google_secret_manager_secret.github-token-secret.secret_id
  policy_data = data.google_iam_policy.serviceagent-secretAccessor.policy_data
}

resource "google_cloudbuildv2_connection" "this" {
  provider = google-beta
  project = var.project
  location = var.region
  name = "${var.project}-github"

  github_config {
    app_installation_id = var.github_cloudbuild_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github-token-secret-version.id
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.policy]
}