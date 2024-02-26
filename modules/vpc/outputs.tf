output "network" {
  value = google_compute_network.main
}

output "subnetwork_main" {
  value = google_compute_subnetwork.main
}

output "subnetwork_proxy" {
  value = google_compute_subnetwork.proxy
}