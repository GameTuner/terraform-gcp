variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "service_name" {
  type        = string
  description = "Used as name qualifier for instances"
}

variable "container_env" {
  type = list(object({
    name = string
    value = string
  }))
  description = "Environment variables to pass to container"
  default = []
}

variable "container_args" {
  type = list(string)
  description = "CLI args variables to pass to container command"
  default = []
}

variable "container_image" {
  type = string
  description = "Url of container image"
}

variable "http_config" {
  type = object({
    health_check_path = string
    port = number
  })
  default = null
}

variable "machine_type" {
  type = string
}

variable "num_instances" {
  type = number
}

variable "service_account_email" {
  type = string
  description = "Service account to attach to the instance."
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "config_dir" {
  type = string
  description = "A config folder that will be mounted on container"
  default = null
}

variable "startup_script" {
  type = string
  description = "If config dir is specified, startup script must generate required files"
  default = ""
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