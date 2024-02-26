output "maxmind_bucket" {
  value = google_storage_bucket.this.name
}

output "maxmind_licence_key" {
  value = var.maxmind_licence_key
}