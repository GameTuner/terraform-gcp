variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "network_url" {
  type = string
}

variable "subnetwork_url" {
  type = string
}

variable "pypi_packages" {
  type = map(string)
  default = {
    pyyaml = "==6.0"
    slack-sdk = "==3.19.5"
    pandas = ">=1.4.4"
  }
}

variable "bq_datasets_location" {
  type = string
}

variable "metadata_ip_address" {
  type = string
}

variable "maxmind_bucket" {
  type = string
  default = null
}

variable "maxmind_licence_key" {
  type = string
  default = null
}


variable "slack_webhook_url" {
  type = string
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

variable "currency_api_key" {
  type = string
  default = null
}

variable "enricher_cloudsql_instance_id" {
  type = string
}

variable "enricher_cloudsql_database_name" {
  type = string
}

variable "enricher_cloudsql_database_user" {
  type = string
}

variable "enricher_cloudsql_database_password" {
  type = string
}