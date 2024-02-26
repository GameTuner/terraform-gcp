variable "project" {
  type = string
}

variable "app_port" {
  type = number
  default = 8080
}

variable "loadbalancer_port" {
  type = number
  default = 80
}

variable "region" {
  type = string
}

variable "bigquery_region" {
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

variable "db_num_cpus" {
  type = number
}

variable "db_memory_mb" {
  type = number
  description = "Minimum is 3840 and must be a multiple of 256"
}

variable "network_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

variable "service_suffix" {
  type = string
  default = ""
}

variable "billing_account" {
  type = string
}

variable "client_projects" {
  type = list(object({
    project_id           = string
    project_display_name = string
  }))
  description = "List of projects for each gametuner client (organization)"
  default     = []
}