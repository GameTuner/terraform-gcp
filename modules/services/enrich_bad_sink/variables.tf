variable "project" {
  type = string
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

variable "proxy_subnetwork" {
  type = string
}

variable "enrich_bad_subscription_name" {
  type = string
}

variable "bigquery_dataset_name" {
  type = string
}

variable "bigquery_table_name" {
  type = string
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