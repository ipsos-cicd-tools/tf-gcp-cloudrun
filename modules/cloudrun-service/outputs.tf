locals {
  service = var.lifecycle_on ? google_cloud_run_v2_service.default_with_lc[0] : google_cloud_run_v2_service.default_no_lc[0]
}

output "service_name" {
  value       = local.service.name
  description = "The name of the Cloud Run service"
}

output "service_uri" {
  value       = local.service.uri
  description = "The main URI serving traffic for this Cloud Run service"
}

output "service_id" {
  value       = local.service.id
  description = "The fully qualified resource ID of the Cloud Run service"
}