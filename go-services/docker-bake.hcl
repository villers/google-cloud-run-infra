variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["gateway", "products", "users"]
}

target "gateway" {
  context    = "go-services/services/gateway"
  dockerfile = "Dockerfile"
  tags       = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/gateway:${TAG}"
  ]
  cache-to   = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/gateway:cache"
  ]
  cache-from = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/gateway:cache"
  ]
}

target "products" {
  context    = "go-services/services/products"
  dockerfile = "Dockerfile"
  tags       = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/products:${TAG}"
  ]
  cache-to   = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/products:cache"
  ]
  cache-from = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/products:cache"
  ]
}

target "users" {
  context    = "go-services/services/users"
  dockerfile = "Dockerfile"
  tags       = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/users:${TAG}"
  ]
  cache-to   = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/users:cache"
  ]
  cache-from = [
    "europe-north1-docker.pkg.dev/ghota-cloud-run-shared/private/users:cache"
  ]
}
