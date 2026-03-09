### Direct VPC (no connector)
```
module "my_service" {
  source = "./modules/cloudrun-service"

  vpc_direct = {
    network    = "my-vpc"
    subnetwork = "my-subnet"
    tags       = ["cloud-run"]
    egress     = "PRIVATE_RANGES_ONLY"
  }
}
```
### Disable IAM entirely (fully public)
```
module "my_service" {
  source = "./modules/cloudrun-service"

  disable_invoker_iam = true  # No IAM check on any request
}
```
### Legacy allUsers IAM binding (old public access approach)
```
module "my_service" {
  source = "./modules/cloudrun-service"

  allow_unauth = true  # Grants allUsers roles/run.invoker via IAM
}
```

<!-- BEGIN_TF_DOCS -->
## Usage
Basic usage of this module is as follows:
```
module "cloudrun-service" {
source  = "git::https://github.com/ipsos-cicd-tools/<repo name>//modules/cloudrun-service?ref=<version number>"

## Required Variables ##
project_id  = 
region  = 
service_name  = 

## Optional Variables ##
allow_unauth  = false
client  = "cloud-console"
cloud_sql_connection  = false
container_port  = 8080
db_connection  = null
disable_invoker_iam  = false
env_secret_vars  = []
env_vars  = []
gcs_volumes  = null
image_path  = "us-docker.pkg.dev/cloudrun/container/hello"
ingress  = "INGRESS_TRAFFIC_ALL"
labels  = {
  "deployedby": "terraform"
}
lifecycle_on  = true
liveness_probe  = null
max_instance_count  = 5
min_instance_count  = 0
nfs_volumes  = null
resources  = null
service_account  = null
startup_probe  = null
timeout  = "60s"
volume_mounts  = null
vpc_connector  = null
vpc_direct  = null
vpc_egress  = "PRIVATE_RANGES_ONLY"
}
```
## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.default_no_lc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service.default_with_lc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service_iam_binding.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_binding) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_unauth"></a> [allow\_unauth](#input\_allow\_unauth) | Allow unauthenticated invocations via IAM allUsers binding. Cannot be used together with disable\_invoker\_iam. | `bool` | `false` | no |
| <a name="input_client"></a> [client](#input\_client) | n/a | `string` | `"cloud-console"` | no |
| <a name="input_cloud_sql_connection"></a> [cloud\_sql\_connection](#input\_cloud\_sql\_connection) | Create a Cloud SQL connection. | `bool` | `false` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port container uses to listen for incoming requests | `number` | `8080` | no |
| <a name="input_db_connection"></a> [db\_connection](#input\_db\_connection) | Required if 'var.cloud\_sql\_connection' is 'true' | `string` | `null` | no |
| <a name="input_disable_invoker_iam"></a> [disable\_invoker\_iam](#input\_disable\_invoker\_iam) | Disable IAM invoker check entirely on the service. No IAM check is performed on any invocation. Simpler than allow\_unauth and takes full precedence over IAM policies. | `bool` | `false` | no |
| <a name="input_env_secret_vars"></a> [env\_secret\_vars](#input\_env\_secret\_vars) | Environment variables (Secret Manager) | <pre>list(object({<br>    name    = string<br>    secret  = string<br>    version = string<br>  }))</pre> | `[]` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables (cleartext) | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| <a name="input_gcs_volumes"></a> [gcs\_volumes](#input\_gcs\_volumes) | GCS volume mounts | <pre>map(object({<br>    name      = string<br>    bucket    = string<br>    read_only = optional(bool, false)<br>  }))</pre> | `null` | no |
| <a name="input_image_path"></a> [image\_path](#input\_image\_path) | n/a | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Possible values are: INGRESS\_TRAFFIC\_ALL, INGRESS\_TRAFFIC\_INTERNAL\_ONLY, INGRESS\_TRAFFIC\_INTERNAL\_LOAD\_BALANCER | `string` | `"INGRESS_TRAFFIC_ALL"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | <pre>{<br>  "deployedby": "terraform"<br>}</pre> | no |
| <a name="input_lifecycle_on"></a> [lifecycle\_on](#input\_lifecycle\_on) | Apply the lifecycle block. | `bool` | `true` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | Configuration for liveness probe. | <pre>object({<br>    failure_threshold     = number<br>    initial_delay_seconds = number<br>    period_seconds        = number<br>    timeout_seconds       = number<br>    http_get_path         = string<br>  })</pre> | `null` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | n/a | `number` | `5` | no |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | n/a | `number` | `0` | no |
| <a name="input_nfs_volumes"></a> [nfs\_volumes](#input\_nfs\_volumes) | values for NFS volume mounts | <pre>map(object({<br>    name      = string<br>    server    = string<br>    path      = string<br>    read_only = optional(bool, false)<br>  }))</pre> | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits | <pre>object({<br>    cpu               = optional(string, null)<br>    memory            = optional(string, null)<br>    cpu_idle          = optional(bool, null)<br>    startup_cpu_boost = optional(bool, null)<br>  })</pre> | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | n/a | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_startup_probe"></a> [startup\_probe](#input\_startup\_probe) | values for startup probe | <pre>object({<br>    failure_threshold     = optional(number, null)<br>    initial_delay_seconds = optional(number, null)<br>    period_seconds        = optional(number, null)<br>    timeout_seconds       = optional(number, null)<br>    http_get_path         = optional(string, null)<br>    port                  = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `string` | `"60s"` | no |
| <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts) | Volume mounts | <pre>map(object({<br>    name       = string<br>    mount_path = string<br>  }))</pre> | `null` | no |
| <a name="input_vpc_connector"></a> [vpc\_connector](#input\_vpc\_connector) | Legacy VPC Access connector name. Format: projects/{project}/locations/{location}/connectors/{connector}. Mutually exclusive with vpc\_direct. | `string` | `null` | no |
| <a name="input_vpc_direct"></a> [vpc\_direct](#input\_vpc\_direct) | Direct VPC egress configuration (no connector required). Mutually exclusive with vpc\_connector. At least one of network or subnetwork must be specified. | <pre>object({<br>    network    = optional(string, null)<br>    subnetwork = optional(string, null)<br>    tags       = optional(list(string), [])<br>    egress     = optional(string, "PRIVATE_RANGES_ONLY")<br>  })</pre> | `null` | no |
| <a name="input_vpc_egress"></a> [vpc\_egress](#input\_vpc\_egress) | Egress setting for legacy VPC connector. Options: PRIVATE\_RANGES\_ONLY or ALL\_TRAFFIC. Only used when vpc\_connector is set. | `string` | `"PRIVATE_RANGES_ONLY"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | The fully qualified resource ID of the Cloud Run service |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Cloud Run service |
| <a name="output_service_uri"></a> [service\_uri](#output\_service\_uri) | The main URI serving traffic for this Cloud Run service |
<!-- END_TF_DOCS -->