resource "google_monitoring_alert_policy" "enrich_bad" {
  display_name = "Number of enricher-bad messages above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "More than 1% events on ${local.service} go in enricher-bad in last 5min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch pubsub_topic
| metric 'pubsub.googleapis.com/topic/send_message_operation_count'
| filter resource.topic_id == 'enricher-bad' || resource.topic_id == 'enricher-good'
| every 1m
| group_by 1m, [agg: aggregate(value.send_message_operation_count)]
| filter_ratio_by [], resource.topic_id == 'enricher-bad'
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

### Check which events started failing
- Check enricher dashboard
- Check `${var.project}.gametuner_monitoring` table in bigquery where bad events are serialized
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "collector_good_latency" {
  display_name = "collector-good oldest message older than threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "collector-good oldest message on ${local.service} is older than 30s in last 15min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "900s"
      query = <<EOF
fetch pubsub_subscription
| metric 'pubsub.googleapis.com/subscription/oldest_unacked_message_age'
| filter resource.subscription_id = 'collector-good-sub'
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

resource "google_monitoring_alert_policy" "event_processing_latency" {
  display_name = "Event processing latency above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "Event processing latency on ${local.service} is greater than 30s in last 15min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "900s"
      query = <<EOF
fetch gce_instance
| metric 'custom.googleapis.com/opencensus/gametuner_enricher/enrich_latency'
| every 1m
| group_by 1m, [value_enrich_latency_max: max(value.enrich_latency)]
| group_by [], [value_enrich_latency_max_max: max(value_enrich_latency_max)]
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
