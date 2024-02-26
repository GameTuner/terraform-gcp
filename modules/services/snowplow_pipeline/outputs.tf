output "collector_ip_address" {
  value = module.collector.ip_address
}

output "maxmind_bucket" {
  value = module.geoip.maxmind_bucket
}

output "maxmind_licence_key" {
  value = module.geoip.maxmind_licence_key
}

output "collector_good_topic_name" {
  value = module.collector.pubsub_good_topic_name
}

output "enricher_bad_subscription_name" {
  value = module.enricher.pubsub_bad_topic_sub_name
}

output "cloudsql_instance_id" {
  value = module.enricher.cloudsql_instance_id
}

output "cloudsql_database_name" {
  value = module.enricher.cloudsql_database_name
}

output "cloudsql_user" {
  value = module.enricher.cloudsql_user
}

output "cloudsql_password" {
  value = module.enricher.cloudsql_password
}