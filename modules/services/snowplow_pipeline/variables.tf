variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "metadata_ip_address" {
  type = string
}

variable "metadata_schemas_url" {
  type = string
}

variable "iglu_config_template_path" {
  type = string
  default = null
}

variable "collector_ssl_config" {
  type = object({
    domains = list(string)
  })
  default = null
}

variable "collector_machine_type" {
  type = string
}

variable "collector_num_instances" {
  type = number
}

variable "collector_config_template_path" {
  type = string
  default = null
}

variable "collector_github_repository" {
  type = object({
    cloudbuild_repository_connection_name = string,
    repository_name = string,
    repository_url = string
  })
}

variable "network_name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

variable "subnetwork_url" {
  type = string
}

variable "machine_distribution_zones" {
  type = list(string)
}

variable "maxmind_licence_key" {
  type = string
}

variable "openexchangerates_licence_key" {
  type = string
}

variable "enricher_machine_type" {
  type = string
}

variable "enricher_num_instances" {
  type = number
}

variable "enricher_config_template_path" {
  type = string
  default = null
}

variable "bigquery_loader_machine_type" {
  type = string
}

variable "enricher_unique_id_db_num_cpus" {
  type = number
}

variable "enricher_unique_id_db_memory_mb" {
  type = number
  description = "Minimum is 3840 and must be a multiple of 256"
}

variable "enricher_github_repository" {
  type = object({
    cloudbuild_repository_connection_name = string,
    repository_name = string,
    repository_url = string
  })
}

variable "bigquery_loader_num_instances" {
  type = number
}

variable "bigquery_loader_config_template_path" {
  type = string
  default = null
}

variable "bigquery_loader_github_repository" {
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

variable "enricher_container_image" {
  type = string
  default = null
}

variable "collector_container_image" {
  type = string
  default = null  
}

variable "bigquery_loader_container_image" {
  type = string
  default = null  
}