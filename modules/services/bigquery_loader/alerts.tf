resource "google_monitoring_alert_policy" "enricher_good_latency" {
  display_name = "enricher-good oldest message older than threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "enricher-good oldest message on ${local.service} is older than 30s in last 15min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "900s"
      query = <<EOF
fetch pubsub_subscription
| metric 'pubsub.googleapis.com/subscription/oldest_unacked_message_age'
| filter resource.subscription_id = 'enricher-good-sub'
| every 1m
| group_by 1m, [oldest_unacked_message_age_max: max(value.oldest_unacked_message_age)]
| group_by [], [oldest_unacked_message_age_max_max: max(oldest_unacked_message_age_max)]
| condition val() > 30000 'ms'
EOF
    }
  }

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    mime_type = "text/markdown"
    content = <<EOF
### Did someone deploy ${local.service} recently?
- Check git repository for commits
- If yes, check with commiter and either quick fix or revert problematic commit

### Check metrics
- Check if we have peaks in traffic
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "loader_bad" {
  display_name = "Number of loader-bad or loader-failed-inserts messages above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "At least 1 message in loader-bad or loader-failed-inserts on ${local.service} in last 1min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "0s"
      query = <<EOF
fetch pubsub_topic
| metric 'pubsub.googleapis.com/topic/send_message_operation_count'
| filter (resource.topic_id == 'loader-bad' || resource.topic_id == 'loader-failed-inserts')
| every 1m
| group_by 1m, [value_send_message_operation_count_aggregate: aggregate(value.send_message_operation_count)]
| condition val() > 0 '1'
EOF
    }
  }

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    mime_type = "text/markdown"
    content = <<EOF
### Did someone deploy ${local.service} recently?
- Check git repository for commits
- If yes, check with commiter and either quick fix or revert problematic commit

### Check pubsub subscription
- Read sample messages to determine if it is a temporary issue or not
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "no_bq_inserts" {
  display_name = "No data inserted in BigQuery on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "Less than 100k rows inserted in BigQuery on ${local.service} in last 15min"

    condition_threshold {
      filter = "resource.type = \"bigquery_project\" AND metric.type = \"bigquery.googleapis.com/storage/insertall_inserted_rows\""
      aggregations {
        alignment_period = "900s"
        per_series_aligner = "ALIGN_SUM"
      }
      comparison = "COMPARISON_LT"
      duration   = "0s"
      trigger {
        percent = 100
      }
      threshold_value = 100000
    }
  }

  conditions {
    display_name = "Missing data inserted metric in BigQuery on ${local.service} in last 15min"

    condition_absent {
      filter = "resource.type = \"bigquery_project\" AND metric.type = \"bigquery.googleapis.com/storage/insertall_inserted_rows\""
      duration   = "900s"
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_SUM"
      }
      trigger {
        percent = 100
      }
    }
  }

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    mime_type = "text/markdown"
    content = <<EOF
### Did someone deploy ${local.service} recently?
- Check git repository for commits
- If yes, check with commiter and either quick fix or revert problematic commit

### Check metrics
- Is BigQuery Loader working? Check dataflow job
- Are all upstream services working? (collector, enricher)
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "publish_errors" {
  display_name = "Number failed pubsub publishes above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "More than 1% events on ${local.service} failed to be published in last 5min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch pubsub_topic
| metric 'pubsub.googleapis.com/topic/send_request_count'
| filter metadata.user_labels.service == '${local.service}'
| every 1m
| group_by 1m, [agg: aggregate(value.send_request_count)]
| filter_ratio_by [], response_class != 'success'
| condition val() > 1.0 '%'
EOF
    }
  }

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    mime_type = "text/markdown"
    content = <<EOF
### Did someone deploy ${local.service} recently?
- Check git repository for commits
- If yes, check with commiter and either quick fix or revert problematic commit

### Check if pubsub is having problems
- Are other services having similar problems?
- Is google communicating incidents?
EOF
  }
  notification_channels = var.alerting_notification_channels
}
