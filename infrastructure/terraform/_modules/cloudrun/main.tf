resource "google_cloud_run_service" "self" {
  provider = google-beta
  name     = var.name
  project  = var.project_id
  location = var.region
  template {
    spec {
      service_account_name = var.service_account_email
      containers {
        image = var.image
        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
          requests = {
            cpu    = var.cpu
            memory = var.memory
          }
        }

        dynamic "env" {
          for_each = var.envs
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"        = var.scale_to_zero ? 0 : 1
        "autoscaling.knative.dev/maxScale"        = 100
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
        "run.googleapis.com/vpc-access-connector" = var.cloudrun_connector_id
      }
    }
  }

  metadata {
    annotations = {
      "serving.knative.dev/lastModifier" = "terraform"
      "run.googleapis.com/client-name"   = "terraform"
      "run.googleapis.com/ingress"       = var.is_internal ? "internal" : "all"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["serving.knative.dev/lastModifier"],
      metadata.0.annotations["run.googleapis.com/client-name"],
    ]
  }
}

resource "google_cloud_run_domain_mapping" "domain_map" {
  count    = var.verified_domain_name != "" ? 1 : 0
  provider = google-beta
  location = google_cloud_run_service.self.location
  name     = var.verified_domain_name
  project  = google_cloud_run_service.self.project

  metadata {
    labels      = var.domain_map_labels
    annotations = var.domain_map_annotations
    namespace   = var.project_id
  }

  spec {
    route_name       = google_cloud_run_service.self.name
    force_override   = var.force_override
    certificate_mode = var.certificate_mode
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    google_cloud_run_service.self
  ]
}

resource "google_cloud_run_service_iam_member" "member" {
  count    = length(var.members)
  location = google_cloud_run_service.self.location
  project  = google_cloud_run_service.self.project
  service  = google_cloud_run_service.self.name
  role     = "roles/run.invoker"
  member   = var.members[count.index]

  depends_on = [
    google_cloud_run_service.self
  ]
}
