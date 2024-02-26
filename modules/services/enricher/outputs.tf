output "pubsub_bad_topic_sub_id" {
  value = google_pubsub_subscription.bad.id
}

output "pubsub_bad_topic_sub_name" {
  value = google_pubsub_subscription.bad.name
}

output "pubsub_good_topic_sub_id" {
  value = google_pubsub_subscription.good.id
}

output "pubsub_good_topic_sub_name" {
  value = google_pubsub_subscription.good.name
}

output "cloudsql_instance_id" {
  value = google_sql_database_instance.uniqueid.connection_name
}

output "cloudsql_database_name" {
  value = local.database_name
}

output "cloudsql_user" {
  value = local.database_user
}

output "cloudsql_password" {
  value = local.database_password
}