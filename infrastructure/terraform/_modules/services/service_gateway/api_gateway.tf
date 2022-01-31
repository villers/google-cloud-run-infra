locals {
  api_config_id_prefix     = "api"
  api_gateway_container_id = "api-gw"
  gateway_id               = "gw"
}
resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = local.api_gateway_container_id
  display_name = "The API Gateway"
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider             = google-beta
  api                  = google_api_gateway_api.api_gw.api_id
  api_config_id_prefix = local.api_config_id_prefix
  display_name         = "The Config"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = base64encode(templatefile("${path.module}/openapi.yaml", {
        address = module.cloudrun.service_url
      }))
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gw" {
  #  region = var.region
  region   = "europe-west1"
  provider = google-beta

  api_config = google_api_gateway_api_config.api_cfg.id

  gateway_id   = local.gateway_id
  display_name = "The Gateway"

  depends_on = [
    google_api_gateway_api_config.api_cfg
  ]
}
