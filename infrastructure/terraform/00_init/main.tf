module "services_shared" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "11.3.1"

  project_id                  = var.shared_project_id
  disable_dependent_services  = false
  disable_services_on_destroy = false

  activate_apis = [
    "artifactregistry.googleapis.com"
  ]
}

module "services_staging_prod" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "11.3.1"

  for_each = toset([var.staging_project_id, var.production_project_id])

  project_id                  = each.value
  disable_dependent_services  = false
  disable_services_on_destroy = false

  activate_apis = [
    "run.googleapis.com",
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
}

module "artifactregistry" {
  source = "../_modules/artifactregistry"

  project_id        = var.shared_project_id
  region            = var.region
  allow_projects_id = [var.staging_project_id, var.production_project_id]

  depends_on = [
    module.services_shared,
    module.services_staging_prod,
  ]
}

resource "google_service_account" "terraform" {
  project      = var.shared_project_id
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
}

resource "google_project_iam_member" "project" {
  for_each = toset([var.shared_project_id, var.staging_project_id, var.production_project_id])
  project  = each.value
  role     = "roles/admin"
  member   = "serviceAccount:${google_service_account.terraform.email}"
}
