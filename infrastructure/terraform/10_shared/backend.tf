terraform {
  backend "gcs" {
    bucket = "ghota-cloud-run-shared"
    prefix = "infrastructure/terraform/10_shared"
  }
}
