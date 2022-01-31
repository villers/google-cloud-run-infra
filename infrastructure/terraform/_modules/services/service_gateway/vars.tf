variable "project_id" {
  type = string
}

variable "region" {
  description = "Region where the app is deployed"
  type        = string
}

variable "cloudrun_connector_id" {
  type = string
}

variable "service_name" {
  type = string
}

variable "image" {
  type = string
}

variable "service_products_url" {
  type = string
}

variable "service_users_url" {
  type = string
}
