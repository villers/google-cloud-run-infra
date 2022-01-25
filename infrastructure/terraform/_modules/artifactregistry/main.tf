data "google_project" "self" {
  for_each   = toset(var.allow_projects_id)
  project_id = each.value
}

resource "google_artifact_registry_repository" "self" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "private"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "self" {
  for_each = toset(var.allow_projects_id)

  provider   = google-beta
  project    = var.project_id
  location   = google_artifact_registry_repository.self.location
  repository = google_artifact_registry_repository.self.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.self[each.key].number}@serverless-robot-prod.iam.gserviceaccount.com"
}
