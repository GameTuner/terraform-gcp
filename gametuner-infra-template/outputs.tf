output "collector_ip_address" {
  value = module.snowplow_pipeline.collector_ip_address
}

output "query_engine_ip_address" {
  value = module.query_engine.ip_address
}

output "metadata_ip_address" {
  value = module.metadata.ip_address
}
