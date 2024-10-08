#   Copyright 2022 Google LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "organization_id" {
  type        = number
  description = "Organization ID"
  default     = 0
}

variable "function_name" {
  type        = string
  description = "Cloud Function name"
}

variable "function_roles" {
  type        = list(string)
  description = "Types of the function to assign permissions"
}

variable "pubsub_topic" {
  type        = string
  description = "Pub/Sub topic (projects/project-id/topics/topic-id)"
  default     = null
}

variable "api" {
  type = object({
    enabled      = optional(bool, false)
    iam_invokers = optional(list(string), [])
  })
  description = "Run the function as API server (eg. non-Pub/Sub)"
  default     = null
}

variable "region" {
  type        = string
  description = "Region to deploy function into"

  default = "europe-west1"
}

variable "trigger_region" {
  type        = string
  description = "Trigger region for Cloud Functions v2 (eg. set to global for Pub/Sub)"

  default = null
}

variable "secret_id" {
  type        = string
  description = "Secret Manager secret ID"

  default = ""
}

variable "config_file" {
  type        = string
  description = "Configuration file (either specify config_file or config)"

  default = "config.yaml"
}

variable "config" {
  type        = string
  description = "Configuration contents (either specify config_file or config)"

  default   = null
  sensitive = true
}

variable "service_account" {
  type        = string
  description = "Service account name"

  default = ""
}

variable "create_service_account" {
  type        = bool
  description = "Create a service account, set false to use service_account as-is."
  default     = true
}

variable "bucket_name" {
  type        = string
  description = "Bucket for storing the Cloud Function"

  default = "cf-pubsub2inbox"
}

variable "bucket_location" {
  type        = string
  description = "Location of a bucket for storing the Cloud Function"

  default = "EU"
}

variable "helper_bucket_name" {
  type        = string
  description = "Helper bucket name for granting IAM permission (storage.objectAdmin)"
  default     = ""
}

variable "function_timeout" {
  type        = number
  description = "Cloud Function timeout (maximum 540 seconds)"
  default     = 240
}

variable "available_memory_mb" {
  type        = number
  description = "Maximum memory the function can use"
  default     = 512
}

variable "available_cpu" {
  type        = number
  description = "Available CPUs to the function"
  default     = null
}

variable "container_concurrency" {
  type        = number
  description = "Concurrency of requests to the container"
  default     = 8
}

variable "retry_minimum_backoff" {
  type        = string
  description = "Minimum retry backoff (value between 0-600 seconds, suffixed with s, default 10s, Cloud Run only)"
  default     = "10s"
}

variable "retry_maximum_backoff" {
  type        = string
  description = "Maximum retry backoff (value between 0-600 seconds, suffixed with s, default 600s, Cloud Run Only)"
  default     = "600s"
}

variable "instance_limits" {
  type = object({
    min_instances = number
    max_instances = number
  })
  description = "Set default min/max instances"
  default = {
    min_instances = 0
    max_instances = 100
  }
}

variable "vpc_connector" {
  type        = string
  description = "VPC connector ID for Cloud Function serverless access"
  default     = null
}

variable "vpc_egress" {
  type = object({
    network    = string
    subnetwork = string
    tags       = optional(string, "pubsub2inbox")
    egress     = optional(string, "all-traffic")
  })
  description = "Direct VPC egress configuration"
  default     = null
}

variable "cloudsql_connection" {
  type        = string
  description = "Cloud SQL connection name"
  default     = null
}

variable "use_local_files" {
  type        = bool
  description = "Use local function files (if set to false, uses http provider to download a release archive from Github)"
  default     = true
}

variable "local_files_path" {
  type        = string
  description = "Local files path when use_local_files is true"
  default     = null
}

variable "release_version" {
  type        = string
  description = "When not using local files, the release version to download"
  default     = "v1.7.0"
}

variable "cloud_run" {
  type        = bool
  description = "Deploy via Cloud Run"
  default     = false
}

variable "cloud_functions_v2" {
  type        = bool
  description = "Deploy via Cloud Functions v2"
  default     = false
}

variable "cloud_run_container" {
  type        = string
  description = "Container URL when deploying via Cloud Run"
  default     = "ghcr.io/googlecloudplatform/pubsub2inbox:v1.4.5"
}

variable "log_level" {
  type        = number
  description = "Set log level (10 equals debug)"
  default     = 10
}

variable "grant_token_creator" {
  type        = bool
  description = "Grant serviceAccountTokenCreator on the service account to itself"
  default     = false
}

variable "deploy_json2pubsub" {
  description = "Deploy Json2Pubsub alongside with this function (eg. for incoming webhooks)"
  type = object({
    enabled         = bool
    suffix          = string
    control_cel     = string
    message_cel     = string
    response_cel    = string
    public_access   = bool
    container_image = string
    min_instances   = number
    max_instances   = number
    grant_sa_user   = string
  })
  default = {
    enabled         = false
    suffix          = "-json2pubsub"
    control_cel     = "false"
    message_cel     = "request.json"
    response_cel    = ""
    public_access   = false
    container_image = null
    min_instances   = 0
    max_instances   = 10
    grant_sa_user   = null
  }
}

variable "ingress_settings" {
  type        = string
  # See
  #   - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function#ingress_settings
  #   - https://cloud.google.com/functions/docs/networking/network-settings#ingress_settings
  description = "VPC Service Controls ingress settings for the Cloud Functions. Default value is ALLOW_ALL. Possible values are: ALLOW_ALL, ALLOW_INTERNAL_ONLY, ALLOW_INTERNAL_AND_GCLB."
  default     = "ALLOW_ALL"
}
