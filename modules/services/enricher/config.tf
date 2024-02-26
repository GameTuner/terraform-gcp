locals {
  unique_id_config = templatefile("${path.module}/templates/enrichments/unique_id_config.json.tmpl", {
    enabled = var.unique_id_enrichment_enabled
    db_connection_name = google_sql_database_instance.uniqueid.connection_name
    db_database = "postgres"
    db_username = "postgres"
    db_password = "enricher"

    cache_size = var.unique_id_cache_size
    cache_expire_after_minutes = var.unique_id_cache_expire_after_minutes
  })
  ip_lookups_config = templatefile("${path.module}/templates/enrichments/ip_lookups.json.tmpl", {
    enabled = var.event_fingerprint_enrichment_enabled
    maxmind_bucket_name = var.maxmind_bucket_name
  })
  currency_conversion_config = templatefile("${path.module}/templates/enrichments/currency_conversion_config.json.tmpl", {
    enabled = var.event_fingerprint_enrichment_enabled
    openexchangerates_licence_key = var.openexchangerates_licence_key == null ? "" : var.openexchangerates_licence_key
  })

  enrichments_list = compact([
    local.unique_id_config,
    local.ip_lookups_config,
    local.currency_conversion_config
  ])

  enrichments = templatefile("${path.module}/templates/enrichments.json.tmpl", { enrichments = join(",", local.enrichments_list) })
}