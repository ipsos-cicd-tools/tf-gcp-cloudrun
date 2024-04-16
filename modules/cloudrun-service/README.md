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
db_connection  = null
env_secret_vars  = []
env_vars  = []
image_path  = "us-docker.pkg.dev/cloudrun/container/hello"
ingress  = "INGRESS_TRAFFIC_ALL"
labels  = {
  "deployedby": "terraform"
}
lifecycle_on  = true
liveness_probe  = null
max_instance_count  = 5
min_instance_count  = 0
resources  = null
service_account  = null
timeout  = "60s"
vpc_connector  = null
vpc_egress  = "PRIVATE_RANGES_ONLY"
}
```
## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_v2_service.default_no_lc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service.default_with_lc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_unauth"></a> [allow\_unauth](#input\_allow\_unauth) | Allow unauthenticated invocations. | `bool` | `false` | no |
| <a name="input_client"></a> [client](#input\_client) | n/a | `string` | `"cloud-console"` | no |
| <a name="input_cloud_sql_connection"></a> [cloud\_sql\_connection](#input\_cloud\_sql\_connection) | Create a Cloud SQL connection. | `bool` | `false` | no |
| <a name="input_db_connection"></a> [db\_connection](#input\_db\_connection) | Required if 'var.cloud\_sql\_connection' is 'true' | `string` | `null` | no |
| <a name="input_env_secret_vars"></a> [env\_secret\_vars](#input\_env\_secret\_vars) | Environment variables (Secret Manager) | <pre>list(object({<br>    name    = string<br>    secret  = string<br>    version = string<br>  }))</pre> | `[]` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables (cleartext) | <pre>list(object({<br>    value = string<br>    name  = string<br>  }))</pre> | `[]` | no |
| <a name="input_image_path"></a> [image\_path](#input\_image\_path) | n/a | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Possible values are: INGRESS\_TRAFFIC\_ALL, INGRESS\_TRAFFIC\_INTERNAL\_ONLY, INGRESS\_TRAFFIC\_INTERNAL\_LOAD\_BALANCER | `string` | `"INGRESS_TRAFFIC_ALL"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | <pre>{<br>  "deployedby": "terraform"<br>}</pre> | no |
| <a name="input_lifecycle_on"></a> [lifecycle\_on](#input\_lifecycle\_on) | Apply the lifecycle block. | `bool` | `true` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | Configuration for liveness probe. | <pre>object({<br>    failure_threshold     = number<br>    initial_delay_seconds = number<br>    period_seconds        = number<br>    timeout_seconds       = number<br>    http_get_path         = string<br>  })</pre> | `null` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | n/a | `number` | `5` | no |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | n/a | `number` | `0` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits | <pre>list(object({<br>    cpu               = optional(string, null)<br>    memory            = optional(string, null)<br>    cpu_idle          = optional(bool, null)<br>    startup_cpu_boost = optional(bool, null)<br>  }))</pre> | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | n/a | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `string` | `"60s"` | no |
| <a name="input_vpc_connector"></a> [vpc\_connector](#input\_vpc\_connector) | n/a | `string` | `null` | no |
| <a name="input_vpc_egress"></a> [vpc\_egress](#input\_vpc\_egress) | The egress setting for the VPC access. Options are PRIVATE\_RANGES\_ONLY or ALL\_TRAFFIC. | `string` | `"PRIVATE_RANGES_ONLY"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | the name of the cloud run service |
<!-- END_TF_DOCS -->