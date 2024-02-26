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

variable "metadata_ip_address" {
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

variable "network_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnetwork_name" {
  type = string
}

variable "pubsub_good_topic" {
  default = "enricher-good"
}

variable "pubsub_collector_good_topic_sub_id" {
  type = string
}

variable "pubsub_bad_topic" {
  default = "enricher-bad"
}

variable "bigtable_num_nodes" {
  type = number
}

variable "log_level" {
  default = "INFO"
  description = "DEBUG, INFO, WARN, ERROR"
}

variable "event_fingerprint_enrichment_enabled" {
  default = true
}

variable "unique_id_enrichment_enabled" {
  default = true
}

variable "unique_id_cache_size" {
  default = 10000
}

variable "unique_id_cache_expire_after_minutes" {
  default = 60
}

variable "unique_id_db_num_cpus" {
  type = number
}

variable "unique_id_db_memory_mb" {
  type = number
  description = "Minimum is 3840 and must be a multiple of 256"
}

variable "iglu_config" {
  type = string
  description = "Iglu config in JSON format"
}

variable "config_path" {
  type = string
  description = "Config path in HOCON format with terraform template variables"
}

variable "maxmind_bucket_name" {
  type = string
}

variable "openexchangerates_licence_key" {
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