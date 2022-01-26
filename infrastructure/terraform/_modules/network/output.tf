output "google_compute_network_id" {
  value = google_compute_network.self.id
}

output "google_vpc_access_connector_id" {
  value = google_vpc_access_connector.cloudrun.id
}
