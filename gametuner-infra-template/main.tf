locals {
  project                           = "<gcp-project-id>"
  project_name                      = "<gcp-project-name>"
  region                            = "<gcp-region>"
  distribution_zones                = ["distribution_zone_1", "distribution_zone_2", "distribution_zone_3"]
  bq_datasets_location              = "<gcp-region>"
  billing_account                   = "<billing-account-id>"
  # This is generated via github, personal access token
  github_token_secret_id            = "<github-secret-id>"
  github_token_secret_value         = "<github-secret-value>"
  github_cloudbuild_installation_id = 46974779
  alerting_notification_channels    = []
  # alerting_notification_channels    = ["projects/${local.project}/notificationChannels/<channel-id>"]
  custom_collector_domain           = ""
  etl_currency_api_key              = ""
  etl_slack_webhook_url             = ""
  maxmind_licence_key               = ""
  openexchangerates_licence_key     = ""
  cloud_build_slack_webhook_url     = ""
  client_projects                   = [
                                      { project_id = "${local.project}-org", project_display_name = "${local.project_name} Organisation" },
                                    ]
}

module "artifact_registry" {
  source = "../modules/artifact_registry"

  project         = local.project
  region          = local.region
  repository_id   = "gametuner-pipeline-services"
}

module "vpc" {
  source  = "../modules/vpc"
  project = local.project
  region  = local.region
}

module "algebraai_github" {
  source = "../modules/cloudbuild_github"

  project                   = local.project
  region                    = local.region
  github_token_secret_value = local.github_token_secret_value
  github_token_secret_id    = local.github_token_secret_id
  github_cloudbuild_installation_id = local.github_cloudbuild_installation_id
}

module "cloudbuild_notifications" {
  source = "../modules/cloudbuild_notifications"

  project           = local.project
  region            = local.region
  slack_webhook_url = local.cloud_build_slack_webhook_url != "" ? local.cloud_build_slack_webhook_url : null
}

module "snowplow_pipeline" {
  source = "../modules/services/snowplow_pipeline"

  metadata_ip_address  = module.metadata.ip_address
  metadata_schemas_url = module.metadata.schemas_url

  collector_machine_type  = "e2-small"
  collector_num_instances = 1
  collector_ssl_config = local.custom_collector_domain != "" ? { domains = [local.custom_collector_domain] } : null
  collector_github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-collector"
    repository_url                        = "https://github.com/GameTuner/collector.git"
  }
  collector_container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-collector:latest"

  enricher_machine_type           = "e2-small"
  enricher_num_instances          = 1
  enricher_unique_id_db_num_cpus  = 1
  enricher_unique_id_db_memory_mb = 3840
  maxmind_licence_key             = local.maxmind_licence_key != "" ? local.maxmind_licence_key : null
  openexchangerates_licence_key   = local.openexchangerates_licence_key != "" ? local.openexchangerates_licence_key : null
  enricher_github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-enricher"
    repository_url                        = "https://github.com/GameTuner/enricher.git"
  }
  enricher_container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-enricher:latest"
  

  bigquery_loader_machine_type  = "e2-small"
  bigquery_loader_num_instances = 1
  bigquery_loader_github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-bigquery-loader"
    repository_url                        = "https://github.com/GameTuner/bigquery-loader.git"
  }
  bigquery_loader_container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-bigquery-loader:latest"
  
  project                    = local.project
  region                     = local.region
  network_id                 = module.vpc.network.id
  network_name               = module.vpc.network.name
  subnetwork_name            = module.vpc.subnetwork_main.name
  subnetwork_url             = module.vpc.subnetwork_main.self_link
  machine_distribution_zones = local.distribution_zones

  alerting_notification_channels = local.alerting_notification_channels
  depends_on                     = [module.vpc] # important for cloudsql
}

module "metadata" {
  source           = "../modules/services/metadata"
  project          = local.project
  machine_type     = "e2-small"
  num_instances    = 1
  network_id       = module.vpc.network.id
  network_name     = module.vpc.network.name
  subnetwork_name  = module.vpc.subnetwork_main.name
  network          = module.vpc.network.name
  subnetwork       = module.vpc.subnetwork_main.name
  proxy_subnetwork = module.vpc.subnetwork_proxy.name
  region           = local.region
  zones            = local.distribution_zones
  github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-metadata"
    repository_url                        = "https://github.com/GameTuner/metadata.git"
  }
  container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-metadata:latest"
  
  alerting_notification_channels = local.alerting_notification_channels
  bigquery_region                = local.bq_datasets_location
  db_num_cpus                    = 1
  db_memory_mb                   = 3840

  client_projects                = local.client_projects
  billing_account                = local.billing_account
  depends_on                     = [module.vpc] # important for cloudsql
}

module "query_engine" {
  source              = "../modules/services/query_engine"
  project             = local.project
  machine_type        = "e2-small"
  num_instances       = 1
  network             = module.vpc.network.name
  subnetwork          = module.vpc.subnetwork_main.name
  proxy_subnetwork    = module.vpc.subnetwork_proxy.name
  region              = local.region
  metadata_ip_address = module.metadata.ip_address
  zones               = local.distribution_zones
  github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-query-engine"
    repository_url                        = "https://github.com/GameTuner/query-engine.git"
  }
  container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-query-engine:latest"
  
  alerting_notification_channels = local.alerting_notification_channels
}

module "etl" {
  source               = "../modules/services/etl"
  project              = local.project
  network_url          = module.vpc.network.self_link
  subnetwork_url       = module.vpc.subnetwork_main.self_link
  region               = local.region
  metadata_ip_address  = module.metadata.ip_address
  maxmind_licence_key  = module.snowplow_pipeline.maxmind_licence_key
  maxmind_bucket       = module.snowplow_pipeline.maxmind_bucket
  bq_datasets_location = local.bq_datasets_location
  slack_webhook_url    = local.etl_slack_webhook_url != "" ? local.etl_slack_webhook_url : null
  github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-etl"
    repository_url                        = "https://github.com/GameTuner/etl.git"
  }
  alerting_notification_channels = local.alerting_notification_channels
  currency_api_key               = local.etl_currency_api_key != "" ? local.etl_currency_api_key : null
  enricher_cloudsql_instance_id = module.snowplow_pipeline.cloudsql_instance_id
  enricher_cloudsql_database_name = module.snowplow_pipeline.cloudsql_database_name
  enricher_cloudsql_database_user = module.snowplow_pipeline.cloudsql_user
  enricher_cloudsql_database_password = module.snowplow_pipeline.cloudsql_password
}

module "enrich_bad_sink" {
  source                       = "../modules/services/enrich_bad_sink"
  project                      = local.project
  machine_type                 = "e2-micro"
  num_instances                = 1
  network                      = module.vpc.network.name
  subnetwork                   = module.vpc.subnetwork_main.name
  proxy_subnetwork             = module.vpc.subnetwork_proxy.name
  region                       = local.region
  zones                        = local.distribution_zones
  enrich_bad_subscription_name = module.snowplow_pipeline.enricher_bad_subscription_name
  bigquery_dataset_name        = "gametuner_monitoring"
  bigquery_table_name          = "enrich_bad_events"
  github_repository = {
    cloudbuild_repository_connection_name = module.algebraai_github.cloudbuild_repository_connection_name,
    repository_name                       = "gametuner-enrich-bad-sink"
    repository_url                        = "https://github.com/GameTuner/enrich-bad-sink.git"
  }
  container_image = "${local.region}-docker.pkg.dev/${local.project}/${module.artifact_registry.artifact_registry_name}/gametuner-enrich-bad-sink:latest"
  
  alerting_notification_channels = local.alerting_notification_channels
}