variable "project_id" {
  type = string
}

variable "region" {
  description = "Region where the app is deployed"
  type        = string
}

variable "scale_to_zero" {
  type    = bool
  default = true
}

variable "is_internal" {
  type    = bool
  default = false
}

variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "cloudrun_connector_id" {
  type = string
}

variable "memory" {
  type    = string
  default = "128Mi"
}

variable "cpu" {
  type    = string
  default = "1000m"
}

variable "envs" {
  type    = map(string)
  default = {}
}

variable "service_account_email" {
  type    = string
  default = ""
}

// Domain Mapping
variable "verified_domain_name" {
  type        = string
  description = "Custom Domain Name"
  default     = ""
}

variable "force_override" {
  type        = bool
  description = "Option to force override existing mapping"
  default     = false
}

variable "certificate_mode" {
  type        = string
  description = "The mode of the certificate (NONE or AUTOMATIC)"
  default     = "NONE"
}

variable "domain_map_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the Domain mapping"
  default     = {}
}

variable "domain_map_annotations" {
  type        = map(string)
  description = "Annotations to the domain map"
  default     = {}
}

// IAM
variable "members" {
  type        = list(string)
  description = "Users/SAs to be given invoker access to the service"
  default = [
    "allUsers"
  ]
}
