module "network" {
  source     = "../_modules/network"
  project_id = var.project_id
  region     = var.region
}

data "docker_registry_image" "self" {
  for_each = toset([
    "products",
    "users",
    "gateway"
  ])
  name = "${var.region}-docker.pkg.dev/${var.shared_project_id}/private/${each.value}:${var.docker_tags}"
}

module "service_products" {
  source = "../_modules/services/service_products"

  project_id            = var.project_id
  region                = var.region
  cloudrun_connector_id = module.network.google_vpc_access_connector_id
  service_name          = "products"
  image                 = "${data.docker_registry_image.self["products"].name}@${data.docker_registry_image.self["products"].sha256_digest}"

  depends_on = [
    module.network
  ]
}

module "service_users" {
  source = "../_modules/services/service_users"

  project_id            = var.project_id
  region                = var.region
  cloudrun_connector_id = module.network.google_vpc_access_connector_id
  service_name          = "users"
  image                 = "${data.docker_registry_image.self["users"].name}@${data.docker_registry_image.self["users"].sha256_digest}"

  depends_on = [
    module.network
  ]
}

module "service_gateway" {
  source = "../_modules/services/service_gateway"

  project_id            = var.project_id
  region                = var.region
  cloudrun_connector_id = module.network.google_vpc_access_connector_id
  service_name          = "gateway"
  image                 = "${data.docker_registry_image.self["gateway"].name}@${data.docker_registry_image.self["gateway"].sha256_digest}"

  service_products_url = module.service_products.service_url
  service_users_url    = module.service_users.service_url

  depends_on = [
    module.service_products,
    module.service_users,
  ]
}
