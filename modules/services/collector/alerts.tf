resource "google_monitoring_alert_policy" "latency" {
  display_name = "Latency above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "95th percentile latency on ${local.service} is greater than 1000ms in last 5min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch https_lb_rule
| metric 'loadbalancing.googleapis.com/https/total_latencies'
| filter (resource.url_map_name == '${local.service}-glb')
| every 1m
| group_by 1m, [value_total_latencies_aggregate: aggregate(value.total_latencies)]
| group_by [], [value_total_latencies_aggregate_percentile: percentile(value_total_latencies_aggregate, 95)]
| condition val() > 1000 'ms'
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
- if latency is comming from load balancer or collector (Load balancer has backend and total latency)
- Check if we have peaks in traffic
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "status500" {
  display_name = "Http 5xx above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "More than 1% requests on ${local.service} return status 5xx in last 5min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch https_lb_rule
| metric loadbalancing.googleapis.com/https/request_count
| filter resource.url_map_name == '${local.service}-glb'
| filter response_code_class != 400
| every 1m
| group_by 1m, [agg: aggregate(value.request_count)]
| filter_ratio_by [], response_code_class = 500
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

### Check metrics
- Check if we have peaks in traffic
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "collector_bad" {
  display_name = "Number of collector-bad messages above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "At least 1 message in collector-bad on ${local.service} in last 1min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch pubsub_topic
| metric 'pubsub.googleapis.com/topic/send_message_operation_count'
| filter (resource.topic_id == 'collector-bad')
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



