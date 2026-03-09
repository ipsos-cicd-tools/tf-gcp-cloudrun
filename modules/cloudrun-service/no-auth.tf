## Allow unauthenticated invocations via IAM allUsers binding.
# Only applies when allow_unauth = true AND disable_invoker_iam = false.
# If disable_invoker_iam = true the service bypasses IAM entirely - no binding needed.
resource "google_cloud_run_v2_service_iam_binding" "noauth" {
  count = var.allow_unauth && !var.disable_invoker_iam ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = var.lifecycle_on ? google_cloud_run_v2_service.default_with_lc[0].name : google_cloud_run_v2_service.default_no_lc[0].name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}