variable "production_project_id" {
  type        = string
  description = "The Google Cloud Platform project id"

  default = "ghota-cloud-run-production"
}

variable "staging_project_id" {
  type        = string
  description = "The Google Cloud Platform project id"

  default = "ghota-cloud-run-staging2"
}

variable "shared_project_id" {
  type        = string
  description = "The Google Cloud Platform project id"
  default     = "ghota-cloud-run-shared"
}

variable "region" {
  description = "Region where the app is deployed"
  type        = string
  default     = "europe-north1"
}
