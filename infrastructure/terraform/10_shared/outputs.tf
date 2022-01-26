output "google_vpc_access_connector_id" {
  value = module.network.google_vpc_access_connector_id
}

output "service_url" {
  value = {
    gateway  = module.service_gateway.service_url
    products = module.service_products.service_url
    users    = module.service_users.service_url
  }
}
