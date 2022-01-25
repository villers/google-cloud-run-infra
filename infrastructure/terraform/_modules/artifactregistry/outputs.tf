output "registry_url" {
  value = "${var.region}-docker.pkg.dev${google_artifact_registry_repository.self.id}"
}
