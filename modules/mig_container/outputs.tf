output "instance_group" {
  value = google_compute_region_instance_group_manager.this.instance_group
}

output "mig_name" {
  value = google_compute_region_instance_group_manager.this.name
}