variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "num_instances" {
  type = number
}

variable "iglu_config" {
  type = string
  description = "Iglu config in JSON format"
}

variable "config_path" {
  type = string
  description = "Config path in HOCON format with terraform template variables"
}

variable "pubsub_enricher_good_topic_sub_name" {
  type = string
}

variable "pubsub_bad_topic" {
  default = "loader-bad"
}

variable "pubsub_failed_inserts_topic" {
  default = "loader-failed-inserts"
}

variable "network" {
  type = string
}

variable "subnetwork_url" {
  type = string
}

variable "container_image" {
  type = string
  description = "Url of container image"
  default = null
}

variable "github_repository" {
  type = object({
    cloudbuild_repository_connection_name = string,
    repository_name = string,
    repository_url = string
  })
}

variable "alerting_notification_channels" {
  type = list(string)
  default = null
}