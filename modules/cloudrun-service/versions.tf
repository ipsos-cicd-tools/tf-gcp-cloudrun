terraform {
  required_version = ">=1.6.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0" # 6.0+ required for invoker_iam_disabled and v2 IAM resources
    }
  }
}