resource "google_cloudfunctions_function" "build_notifications" {
  name        = "cloud-build-notifications"
  description = "Cloud Build Notifications"
  runtime     = "python39"
  entry_point = "subscribe"

  source_archive_bucket = google_storage_bucket.notification_bucket.name
  source_archive_object = google_storage_bucket_object.notification_source.name

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.cloud-builds.id
  }

  environment_variables = {
    SLACK_WEBHOOK_URL = var.slack_webhook_url
  }

  docker_registry = "ARTIFACT_REGISTRY"
}

resource "google_storage_bucket" "notification_bucket" {
  name     = "${var.project}-cloud-build-notifications"
  location      = upper(var.region)
  force_destroy = true
}


data "archive_file" "notification_source_archived" {
  type        = "zip"
  source_dir  = "${path.module}/source"
  output_path = "${path.module}/dist/main.zip"
}

resource "google_storage_bucket_object" "notification_source" {
  name   = "main.zip"
  bucket = google_storage_bucket.notification_bucket.name
  source = data.archive_file.notification_source_archived.output_path
}

resource "google_pubsub_topic" "cloud-builds" {
  name         = "cloud-builds"
}