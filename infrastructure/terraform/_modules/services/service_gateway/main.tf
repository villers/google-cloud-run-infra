module "cloudrun" {
  source = "../../cloudrun"

  project_id = var.project_id
  region     = var.region

  name                  = var.service_name
  image                 = var.image
  cloudrun_connector_id = var.cloudrun_connector_id
  scale_to_zero         = true
  is_internal           = false

  envs = {
    SERVICE_PRODUCTS_URL = var.service_products_url
    SERVICE_USERS_URL    = var.service_users_url
  }
}
