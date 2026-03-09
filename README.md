# Terraform GCP Cloud Run Module

Module to deploy:
  * Cloud Run service

## Compatibility

* Terraform version >= 1.6.6
* hashicorp/google version >= 6.0.0

## Usage

More specific usage examples can be found in the ***modules/cloudrun-service/example*** folder.

### Basic Example

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
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
  cloud_sql_connection = false
  min_instance_count   = 0
  max_instance_count   = 3
  lifecycle_on         = true

  # Public access - choose ONE of the two options below
  allow_unauth        = false # Option 1: IAM allUsers binding
  disable_invoker_iam = false # Option 2: Bypass IAM check entirely (simpler)

  resources = {
    cpu               = "1"
    memory            = "256Mi"
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
      secret  = "secret_key" # use self-link if in a different project
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

  startup_probe = {
    failure_threshold     = 3
    initial_delay_seconds = 0
    period_seconds        = 10
    timeout_seconds       = 2
    port                  = 8080
  }

  gcs_volumes = {
    "bucket1" = {
      name      = "gcs-volume1"
      bucket    = "bucket-name"
      read_only = false
    }
  }

  volume_mounts = {
    "mount1" = {
      name       = "gcs-volume1"
      mount_path = "/mnt/mount-name"
    }
  }
}
```

---

### Direct VPC Access (no connector required)

Use `vpc_direct` for lower latency private networking without needing a VPC Access Connector resource.
`vpc_direct` and `vpc_connector` are **mutually exclusive** - use only one.

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"

  vpc_direct = {
    network    = "my-vpc"
    subnetwork = "my-subnet"
    tags       = ["cloud-run"]         # optional: network tags
    egress     = "PRIVATE_RANGES_ONLY" # options: PRIVATE_RANGES_ONLY or ALL_TRAFFIC
  }
}
```

### Legacy VPC Connector

Use `vpc_connector` if you have an existing VPC Access Connector resource.

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"

  vpc_connector = "projects/my-project/locations/us-central1/connectors/my-connector"
  vpc_egress    = "PRIVATE_RANGES_ONLY" # options: PRIVATE_RANGES_ONLY or ALL_TRAFFIC
}
```

---

### Public Access Options

> ⚠️ `allow_unauth` and `disable_invoker_iam` are mutually exclusive - use only one.

#### Option 1: Disable IAM entirely (recommended for simple public services)

Bypasses the IAM invoker check on the service entirely. No IAM policy binding is created.

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"

  disable_invoker_iam = true
}
```

#### Option 2: IAM allUsers binding

Grants the `roles/run.invoker` role to `allUsers` via an IAM binding.
Provides more granular audit trail but requires an IAM resource.

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"

  allow_unauth = true
}
```

---

### NFS Volume Mount

```hcl
module "cloudrun" {
  source       = "git::https://github.com/ipsos-cicd-tools/tf-gcp-cloudrun//modules/cloudrun-service?ref=1.3.0"
  project_id   = var.project_id
  region       = var.region
  service_name = "test-service"

  nfs_volumes = {
    "nfs1" = {
      name      = "nfs-volume"
      server    = "10.0.0.2"   # NFS server hostname or IP
      path      = "/share1"    # exported path on the NFS server
      read_only = false
    }
  }

  volume_mounts = {
    "mount1" = {
      name       = "nfs-volume"
      mount_path = "/mnt/nfs"
    }
  }

  # Direct VPC required for NFS access
  vpc_direct = {
    network    = "my-vpc"
    subnetwork = "my-subnet"
  }
}
```

---

## `allow_unauth` vs `disable_invoker_iam`

| | `allow_unauth` | `disable_invoker_iam` |
|---|---|---|
| **Mechanism** | IAM binding granting `allUsers` the invoker role | Bypasses IAM check entirely on the service |
| **IAM resource created** | ✅ Yes | ❌ No |
| **Audit logs** | ✅ Logged via IAM | ⚠️ IAM check skipped |
| **Best for** | APIs needing IAM audit trail | Simple public websites / services |
| **Reversible** | ✅ Remove binding | ✅ Set to `false` |

