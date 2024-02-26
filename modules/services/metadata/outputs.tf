output "ip_address" {
  value = google_compute_forwarding_rule.this.ip_address
}

output "schemas_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.schemas.name}/"
}