resource "google_project_iam_member" "pubsub_viewer" {
  project = var.project
  role   = "roles/pubsub.viewer"
  member = "serviceAccount:${google_service_account.this.email}"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_project_iam_member" "pubsub_publisher" {
  project = var.project
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.this.email}"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_pubsub_topic" "good" {
  name         = var.pubsub_good_topic
  labels = {
    service = local.service
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_pubsub_subscription" "good" {
  name  = "${google_pubsub_topic.good.name}-sub"
  topic = google_pubsub_topic.good.name

  labels = {
    service = local.service
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_pubsub_topic" "bad" {
  name         = var.pubsub_bad_topic
  labels = {
    service = local.service
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_pubsub_subscription" "bad" {
  name  = "${google_pubsub_topic.bad.name}-sub"
  topic = google_pubsub_topic.bad.name

  labels = {
    service = local.service
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}