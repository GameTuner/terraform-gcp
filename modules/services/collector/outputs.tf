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

output "ip_address" {
  value = google_compute_global_address.this.address
}

output "pubsub_good_topic_name" {
  value = google_pubsub_topic.good.name
}