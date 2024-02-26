variable "project" {
  type = string
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "loadbalancer_port" {
  type    = number
  default = 80
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "container_image" {
  type        = string
  description = "Url of container image"
  default     = null
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

variable "metadata_ip_address" {
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

variable "service_suffix" {
  type = string
  default = ""
}

variable "num_uvicorn_processes" {
  type = number
  default = 1
}