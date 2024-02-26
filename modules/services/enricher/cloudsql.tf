locals {
  database_name = "postgres"
  database_user = "postgres"
  database_password = "enricher"
}

resource "google_sql_database_instance" "uniqueid" {
  name             = "${local.service}-unique-id"
  database_version = "POSTGRES_14"
  region           = var.region
  deletion_protection = false
  root_password = local.database_password


  settings {
    tier = "db-custom-${var.unique_id_db_num_cpus}-${var.unique_id_db_memory_mb}"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = var.network_id
      enable_private_path_for_google_cloud_services = true
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

    database_flags {
      name  = "max_connections"
      value = 200
    }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

module "cloudsql_bastion" {
  source = "../../cloudsql_bastion"
  name = local.service
  instance_connection_name = google_sql_database_instance.uniqueid.connection_name
  database_name = local.database_name
  database_username = local.database_user
  database_password = local.database_password
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