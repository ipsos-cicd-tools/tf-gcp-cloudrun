module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.1.1"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"
  timeout      = "120s"
  ingress      = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  labels = {
    deployedby = "terraform"
  }
  image_path           = "us-docker.pkg.dev/cloudrun/container/hello"
  service_account      = null
  db_connection        = null
  vpc_connector        = null
  cloud_sql_connection = false
  min_instance_count   = 0
  max_instance_count   = 3
  allow_unauth         = true
  lifecycle_on         = true
  resources = {
    cpu    = "1"
    memory = "256Mi"
    startup_cpu_boost = false
  }
  env_vars = [
    {
      name  = "TEST-ENVVAR"
      value = "test"
    }
  ]
  env_secret_vars = [
    {
      name    = "TEST-SECRET"
      secret  = "secret_key" # use self-link if in different project
      version = "latest"
    },
  ]
  liveness_probe = {
    failure_threshold     = 3
    initial_delay_seconds = 0
    period_seconds        = 10
    timeout_seconds       = 2
    http_get_path         = "/healthcheck/"
  }
}