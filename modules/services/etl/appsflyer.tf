resource "google_storage_bucket" "dataproc_service" {
  project = var.project
  name          = "${var.project}-etl-dataproc"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket" "appsflyer_data_locker" {
  project = var.project
  name          = "${var.project}-data-locker"
  location      = upper(var.region)
  force_destroy = true
}
