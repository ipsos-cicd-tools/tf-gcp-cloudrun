output "service_name" {
  value       = var.lifecycle_on ? google_cloud_run_v2_service.default_with_lc[0].name : google_cloud_run_v2_service.default_no_lc[0].name
  description = "The name of the cloud run service"
}