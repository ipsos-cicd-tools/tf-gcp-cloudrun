resource "google_cloud_run_v2_service" "default_with_lc" {
  count    = var.lifecycle_on ? 1 : 0
  name     = var.service_name
  location = var.region
  ingress  = var.ingress
  client   = var.client

  labels = var.labels

  launch_stage = var.volume_mounts != null ? "BETA" : "GA"

  template {
    service_account = var.service_account
    timeout         = var.timeout

    containers {
      image = var.image_path

      ports {
        container_port = var.container_port
      }

      dynamic "resources" {
        for_each = var.resources != null ? [var.resources] : []
        content {
          startup_cpu_boost = resources.value.startup_cpu_boost != null ? resources.value.startup_cpu_boost : null
          cpu_idle          = resources.value.cpu_idle != null ? resources.value.cpu_idle : true
          limits = {
            cpu    = resources.value.cpu != null ? resources.value.cpu : null
            memory = resources.value.memory != null ? resources.value.memory : null
          }
        }
      }

      dynamic "volume_mounts" {
        for_each = var.cloud_sql_connection ? [1] : []
        content {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
      }

      dynamic "volume_mounts" {
        for_each = var.volume_mounts != null ? var.volume_mounts : {}
        content {
          name       = volume_mounts.value.name
          mount_path = volume_mounts.value.mount_path
        }
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.value["name"]
          value = env.value["value"]
        }
      }

      dynamic "env" {
        for_each = var.env_secret_vars
        content {
          name = env.value["name"]
          value_source {
            secret_key_ref {
              secret  = env.value["secret"]
              version = env.value["version"]
            }
          }
        }
      }


      dynamic "liveness_probe" {
        for_each = var.liveness_probe != null ? [var.liveness_probe] : []
        content {
          failure_threshold     = liveness_probe.value.failure_threshold
          initial_delay_seconds = liveness_probe.value.initial_delay_seconds
          period_seconds        = liveness_probe.value.period_seconds
          timeout_seconds       = liveness_probe.value.timeout_seconds

          http_get {
            path = liveness_probe.value.http_get_path
          }
        }
      }

      dynamic "startup_probe" {
        for_each = var.startup_probe != null ? [var.startup_probe] : []
        content {
          failure_threshold     = startup_probe.value.failure_threshold
          initial_delay_seconds = startup_probe.value.initial_delay_seconds
          period_seconds        = startup_probe.value.period_seconds
          timeout_seconds       = startup_probe.value.timeout_seconds
          tcp_socket {
            port = startup_probe.value.port
          }
        }
      }
    }

    dynamic "volumes" {
      for_each = var.cloud_sql_connection ? [1] : []
      content {
        name = "cloudsql"
        cloud_sql_instance {
          instances = [var.db_connection]
        }
      }
    }

    dynamic "volumes" {
      for_each = var.gcs_volumes != null ? var.gcs_volumes : {}
      content {
        name = volumes.value.name
        gcs {
          bucket    = volumes.value.bucket
          read_only = volumes.value.read_only
        }
      }
    }

    dynamic "volumes" {
      for_each = var.nfs_volumes != null ? var.nfs_volumes : {}
      content {
        name = volumes.value.name
        nfs {
          server    = volumes.value.bucket
          path      = volumes.value.path
          read_only = volumes.value.read_only
        }
      }
    }

    dynamic "vpc_access" {
      for_each = var.vpc_connector != null ? [1] : []
      content {
        connector = var.vpc_connector
        egress    = var.vpc_egress
      }
    }

    scaling {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to images, e.g. devs changing the image tag.
      template[0].containers[0].image,
      template[0].containers[0].name,
      client_version,
      client
    ]
  }
}