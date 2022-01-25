variable "project_id" {
  type        = string
  description = "The Google Cloud Platform project id"
}

variable "allow_projects_id" {
  description = "Allow cloudrun projects to read registry"
  type        = list(string)
}

variable "region" {
  description = "Region where the app is deployed"
  type        = string
}
