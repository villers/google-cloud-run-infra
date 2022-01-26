terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.8"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.8"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }

  required_version = ">= 0.15"
}
