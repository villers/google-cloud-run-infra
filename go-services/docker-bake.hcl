variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["gateway", "products", "users"]
}

target "gateway" {
  context = "services/gateway"
  dockerfile = "Dockerfile"
  pull = true
  tags = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/gateway:${TAG}"
  ]
}

target "products" {
  context = "services/products"
  dockerfile = "Dockerfile"
  tags = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/products:${TAG}"
  ]
}

target "users" {
  context = "services/users"
  dockerfile = "Dockerfile"
  tags = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/users:${TAG}"
  ]
}
