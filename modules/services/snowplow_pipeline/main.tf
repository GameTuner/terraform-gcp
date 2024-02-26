data "template_file" "iglu_config" {
  template = file(coalesce(var.iglu_config_template_path, "${path.module}/templates/iglu_config.json.tmpl"))

  vars = {
    metadata_ip_address = var.metadata_ip_address
    metadata_schemas_url = var.metadata_schemas_url
  }
}

module "collector" {
  source        = "../collector"
  project       = var.project
  machine_type  =  var.collector_machine_type
  num_instances = var.collector_num_instances
  network       = var.network_name
  subnetwork    = var.subnetwork_name
  region        = var.region
  zones         = var.machine_distribution_zones
  config_path = coalesce(var.collector_config_template_path, "${path.module}/templates/collector_config.hocon.tmpl")
  iglu_config = data.template_file.iglu_config.rendered
  ssl_config  = var.collector_ssl_config
  github_repository = var.collector_github_repository
  alerting_notification_channels = var.alerting_notification_channels
  container_image = var.collector_container_image != null ? var.collector_container_image : null
}

module "geoip" {
  source           = "../../geoip"
  project          = var.project
  region           = var.region
  maxmind_licence_key = var.maxmind_licence_key
}

module "enricher" {
  source                                 = "../enricher"
  project                                = var.project
  machine_type                           = var.enricher_machine_type
  num_instances                          = var.enricher_num_instances
  bigtable_num_nodes                     = 1
  network_id                             = var.network_id
  network_name                           = var.network_name
  subnetwork_name                        = var.subnetwork_name
  region                                 = var.region
  zones                                  = var.machine_distribution_zones
  pubsub_collector_good_topic_sub_id     = module.collector.pubsub_good_topic_sub_id
  config_path = coalesce(var.enricher_config_template_path, "${path.module}/templates/enricher_config.hocon.tmpl")
  iglu_config = data.template_file.iglu_config.rendered
  maxmind_bucket_name = module.geoip.maxmind_bucket
  openexchangerates_licence_key = var.openexchangerates_licence_key
  metadata_ip_address = var.metadata_ip_address
  unique_id_db_num_cpus = var.enricher_unique_id_db_num_cpus
  unique_id_db_memory_mb = var.enricher_unique_id_db_memory_mb
  github_repository = var.enricher_github_repository
  alerting_notification_channels = var.alerting_notification_channels
  container_image = var.enricher_container_image != null ? var.enricher_container_image : null
}

module "bigquery_loader" {
  source                                 = "../bigquery_loader"
  project                                = var.project
  machine_type                           = var.bigquery_loader_machine_type
  num_instances                          = var.bigquery_loader_num_instances
  network                                = var.network_id
  subnetwork_url                         = var.subnetwork_url
  region                                 = var.region
  config_path = coalesce(var.bigquery_loader_config_template_path, "${path.module}/templates/bigquery_loader_config.hocon.tmpl")
  iglu_config = data.template_file.iglu_config.rendered
  pubsub_enricher_good_topic_sub_name = module.enricher.pubsub_good_topic_sub_name
  github_repository = var.bigquery_loader_github_repository
  alerting_notification_channels = var.alerting_notification_channels
  container_image = var.bigquery_loader_container_image != null ? var.bigquery_loader_container_image : null
}

