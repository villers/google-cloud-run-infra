locals {
  cloudrun_net_range = "10.8.0.0/28"

  firewall_nat_ip_ranges         = ["107.178.230.64/26", "35.199.224.0/19", ]
  firewall_healthcheck_ip_ranges = ["130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23", ]
}

resource "google_compute_network" "self" {
  project                 = var.project_id
  name                    = "vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cloudrun" {
  project                  = var.project_id
  name                     = "cloudrun-subnet"
  ip_cidr_range            = local.cloudrun_net_range
  region                   = var.region
  network                  = google_compute_network.self.id
  private_ip_google_access = true
}

resource "google_vpc_access_connector" "cloudrun" {
  provider = google-beta

  project      = var.project_id
  region       = var.region
  name         = "cloudrun-connector"
  machine_type = "f1-micro"

  subnet {
    name = google_compute_subnetwork.cloudrun.name
  }
}

resource "google_compute_router" "self" {
  provider = google-beta
  name     = "router"
  region   = var.region
  network  = google_compute_network.self.id
}

resource "google_compute_router_nat" "self" {
  provider = google-beta

  name                                = "router"
  router                              = google_compute_router.self.name
  region                              = var.region
  min_ports_per_vm                    = 64
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_endpoint_independent_mapping = false

  log_config {
    enable = false
    filter = "ALL"
  }
}
