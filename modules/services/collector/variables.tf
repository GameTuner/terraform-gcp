variable "project" {
  type = string
}

variable "app_port" {
  type = number
  default = 8080
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "container_image" {
  type = string
  description = "Url of container image"
  default = null
}

variable "machine_type" {
  type = string
}

variable "num_instances" {
  type = number
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "pubsub_good_topic" {
  default = "collector-good"
}

variable "pubsub_bad_topic" {
  default = "collector-bad"
}

variable "iglu_config" {
  type = string
  description = "Iglu config in JSON format"
}

variable "config_path" {
  type = string
  description = "Config path in HOCON format with terraform template variables"
}

variable "ssl_config" {
  type = object({
    domains = list(string)
  })
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