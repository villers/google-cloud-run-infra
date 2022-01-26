output "service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_service.self.status[0].url
}
