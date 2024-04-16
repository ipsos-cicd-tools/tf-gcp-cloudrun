variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "service_name" {
  type = string
}

variable "labels" {
  type = map(string)
  default = {
    deployedby = "terraform"
  }
}

variable "image_path" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "service_account" {
  type    = string
  default = null
}

variable "db_connection" {
  type        = string
  default     = null
  description = "Required if 'var.cloud_sql_connection' is 'true'"
}

variable "env_vars" {
  type = list(object({
    value = string
    name  = string
  }))
  description = "Environment variables (cleartext)"
  default     = []
}

variable "env_secret_vars" {
  type = list(object({
    name    = string
    secret  = string
    version = string
  }))
  description = "Environment variables (Secret Manager)"
  default     = []
}

variable "timeout" {
  type    = string
  default = "60s"
}

variable "vpc_connector" {
  type    = string
  default = null
}

variable "max_instance_count" {
  type    = number
  default = 5
}

variable "min_instance_count" {
  type    = number
  default = 0
}

variable "client" {
  type    = string
  default = "cloud-console"
}

variable "ingress" {
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
  description = "Possible values are: INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
}

variable "cloud_sql_connection" {
  description = "Create a Cloud SQL connection."
  type        = bool
  default     = false
}

variable "vpc_egress" {
  description = "The egress setting for the VPC access. Options are PRIVATE_RANGES_ONLY or ALL_TRAFFIC."
  type        = string
  default     = "PRIVATE_RANGES_ONLY" # Set a sensible default or make it mandatory by not setting a default.
}

variable "liveness_probe" {
  description = "Configuration for liveness probe."
  type = object({
    failure_threshold     = number
    initial_delay_seconds = number
    period_seconds        = number
    timeout_seconds       = number
    http_get_path         = string
  })
  default = null
}

variable "allow_unauth" {
  description = "Allow unauthenticated invocations."
  type        = bool
  default     = false
}

variable "lifecycle_on" {
  description = "Apply the lifecycle block."
  type        = bool
  default     = true
}

variable "resources" {
  type = list(object({
    cpu               = optional(string, null)
    memory            = optional(string, null)
    cpu_idle          = optional(bool, null)
    startup_cpu_boost = optional(bool, null)
  }))
  description = "Resource limits"
  default     = null
}

