# NETWORK
###############################################################
# 10.128.0.0/9 (10.128.0.0 - 10.255.255.255) is range for whole network
# subnets should take 10.128.0.0/20, 10.130.0.0/20, 10/132.0.0/20, etc

resource "google_compute_network" "main" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "main-subnet-${var.region}"
  ip_cidr_range = "10.128.0.0/20"
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true
}

# proxy-only subnet needed for internal https load balancer
resource "google_compute_subnetwork" "proxy" {
  name          = "ilb-proxy-subnet-${var.region}"
  provider      = google-beta
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = google_compute_network.main.name
}
###############################################################

# NAT
###############################################################
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.main.name
}

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
###############################################################

# FIREWALL
###############################################################
# consider making this strict in the future
resource "google_compute_firewall" "allow_internal" {
  name          = "allow-internal"
  network       = google_compute_network.main.name
  source_ranges = ["10.128.0.0/9"]
  priority      = 65534

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

# necessary for gcp healthchecks to work
resource "google_compute_firewall" "allow_healthcheck" {
  name          = "allow-healthcheck"
  network       = google_compute_network.main.name
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

# enables SSH through gcloud
resource "google_compute_firewall" "allow_iap" {
  name          = "allow-iap"
  network       = google_compute_network.main.name
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# necessary for internal load balancer
resource "google_compute_firewall" "proxy_http" {
  name          = "allow-http-from-proxy"
  provider      = google-beta
  network       = google_compute_network.main.name
  source_ranges = [google_compute_subnetwork.proxy.ip_cidr_range]
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

# Network connection for managed services with private ip (cloudsql for example)
###############################################################

resource "google_compute_global_address" "managed_services" {
  provider      = google-beta
  project       = var.project
  name          = "google-managed-services-${google_compute_network.main.name}"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  address_type  = "INTERNAL"
  network       = google_compute_network.main.self_link
}

# provider is set to google-beta because of known issue with destroying resource
# with provider 5.x. More info: https://github.com/hashicorp/terraform-provider-google/issues/16275
resource "google_service_networking_connection" "managed_services" {
  network                 = google_compute_network.main.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.managed_services.name]
  provider = google-beta
}

resource "google_compute_network_peering_routes_config" "managed_services" {
  peering              = google_service_networking_connection.managed_services.peering
  network              = google_compute_network.main.name
  import_custom_routes = true
  export_custom_routes = true
}