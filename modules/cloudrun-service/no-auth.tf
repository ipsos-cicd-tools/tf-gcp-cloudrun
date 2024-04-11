## Allow unauthenticated invocations
data "google_iam_policy" "noauth" {
  count = var.allow_unauth ? 1 : 0

  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  count = var.allow_unauth ? 1 : 0

  location    = var.region
  project     = var.project_id
  service     = var.lifecycle_on ? google_cloud_run_v2_service.default_with_lc[0].name : google_cloud_run_v2_service.default_no_lc[0].name
  policy_data = data.google_iam_policy.noauth[0].policy_data
}