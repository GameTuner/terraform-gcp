output "web_ui_url" {
  value = google_composer_environment.etl.config.0.airflow_uri
}