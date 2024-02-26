locals {
  service = "geoip"
}

resource "google_storage_bucket" "this" {
  project = var.project
  name          = "${var.project}-${local.service}"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket_object" "default_db" {
  name   = "GeoLite2-City.mmdb"
  bucket = google_storage_bucket.this.name
  source = "${path.module}/db/GeoLite2-City.mmdb"
  detect_md5hash = false
  lifecycle {
    ignore_changes = all
  }
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.this.name
  role   = "READER"
  entity = "allUsers"
}