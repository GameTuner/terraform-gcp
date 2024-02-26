resource "google_project_iam_member" "bigquery_agent_cloudsql" {
  project = data.google_project.this.project_id
  role    = "roles/cloudsql.client"
  member  = format("serviceAccount:%s",
    format("service-%s@gcp-sa-bigqueryconnection.iam.gserviceaccount.com", data.google_project.this.number))

  # service account is automatically created after first connection is created
  depends_on = [google_bigquery_connection.connection]
}

resource "google_project_iam_member" "bigquery-connection-user" {
  project  = var.project
  role     = "roles/bigquery.connectionUser"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_bigquery_connection" "connection" {
  connection_id = "enricher-unique-id-db"
  description   = "Connection to enricher unique id database"
  location      = var.bq_datasets_location
  cloud_sql {
    instance_id = var.enricher_cloudsql_instance_id
    database    = var.enricher_cloudsql_database_name
    type        = "POSTGRES"
    credential {
      username = var.enricher_cloudsql_database_user
      password = var.enricher_cloudsql_database_password
    }
  }
}