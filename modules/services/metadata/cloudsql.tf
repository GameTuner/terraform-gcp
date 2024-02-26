resource "google_sql_database_instance" "db" {
  name             = "${local.service}-db"
  database_version = "POSTGRES_14"
  region           = var.region
  deletion_protection = false
  root_password = "metadata"

  settings {
    tier = "db-custom-${var.db_num_cpus}-${var.db_memory_mb}"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = var.network_id
    }

    backup_configuration {
      enabled = true
      point_in_time_recovery_enabled = true
    }

    insights_config {
      query_insights_enabled = true
      record_application_tags = false
      record_client_address = false
    }

    user_labels = {
      service = local.service
    }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

module "cloudsql_bastion" {
  source = "../../cloudsql_bastion"
  name = local.service
  instance_connection_name = google_sql_database_instance.db.connection_name
  database_name = "postgres"
  database_username = "postgres"
  database_password = "metadata"
  network_name = var.network_name
  subnetwork_name = var.subnetwork_name
  zone = var.zones[0]
  service_account_email = google_service_account.this.email
}

resource "google_project_iam_member" "cloudsql" {
  project = var.project
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.this.email}"
}
