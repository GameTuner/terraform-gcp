resource "google_monitoring_alert_policy" "status500" {
  display_name = "Http 5xx above threshold on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "At least 10 requests on ${local.service} return status 5xx in last 5min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch internal_http_lb_rule
| metric loadbalancing.googleapis.com/https/internal/request_count
| filter backend_name == '${local.service}-mig'
| filter response_code_class == 500
| every 5m
| group_by 5m, [agg: aggregate(value.request_count)]
| condition val() > 10 '1'
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
EOF
  }
  notification_channels = var.alerting_notification_channels
}

resource "google_monitoring_alert_policy" "maintainer_errors" {
  display_name = "There are maintainer errors on ${local.service}"
  combiner     = "OR"
  conditions {
    display_name = "At least 1 maintainer error in on ${local.service} in last 1min"

    condition_monitoring_query_language {
      trigger {
        count = "1"
      }
      duration   = "300s"
      query = <<EOF
fetch generic_node
| metric 'custom.googleapis.com/gametuner_metadata/maintainer_errors'
| every 1m
| group_by 1m, [value_maintainer_errors_aggregate: aggregate(value.maintainer_errors)]
| condition val() > 0 '1'
EOF
    }
  }

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content = <<EOF
### Did someone deploy ${local.service} recently?
- Check git repository for commits
- If yes, check with commiter and either quick fix or revert problematic commit

### Check why maintainer is failing
- Check logs
- Find event, raw schema, app, organization, etc with status != SUCCESS to determine problematic row
EOF
  }
  notification_channels = var.alerting_notification_channels
}