module "dashboard_vm" {
  source     = "../../dashboard_templates/dashboard_vm"
  service = local.service
  offset = 6
}

module "dashboard_cloudsql" {
  source     = "../../dashboard_templates/dashboard_cloudsql"
  project = var.project
  service = local.service
  offset = module.dashboard_vm.offset + module.dashboard_vm.height
}

resource "google_monitoring_dashboard" "this" {
  lifecycle {
    ignore_changes = [
      dashboard_json
    ]
  }

  dashboard_json = <<EOF
{
  "dashboardFilters": [
    {
      "filterType": "METRIC_LABEL",
      "labelKey": "app_id",
      "templateVariable": "app_id"
    },
    {
      "filterType": "METRIC_LABEL",
      "labelKey": "event_name",
      "templateVariable": "event_name"
    },
    {
      "filterType": "METRIC_LABEL",
      "labelKey": "error",
      "templateVariable": "error"
    }
  ],
  "displayName": "Gametuner Enricher",
  "labels": {},
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 3,
        "widget": {
          "title": "Event Throughput",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "legendTemplate": "collector received events",
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" resource.label.\"url_map_name\"=\"gametuner-collector-glb\" metric.label.\"response_code_class\"=\"200\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              },
              {
                "legendTemplate": "acked collector events",
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\" resource.type=\"pubsub_subscription\" resource.label.\"subscription_id\"=\"collector-good-sub\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              },
              {
                "legendTemplate": "enricher-good",
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" resource.label.\"topic_id\"=\"enricher-good\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 4
      },
      {
        "height": 3,
        "widget": {
          "title": "Latency",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MAX",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MAX"
                    },
                    "filter": "metric.type=\"custom.googleapis.com/opencensus/gametuner_enricher/enrich_latency\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              },
              {
                "legendTemplate": "oldest collector good message",
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/oldest_unacked_message_age_by_region\" resource.type=\"pubsub_topic\" resource.label.\"topic_id\"=\"collector-good\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        },
        "width": 4,
        "xPos": 4
      },
      {
        "height": 3,
        "widget": {
          "title": "Bad Topic",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" resource.label.\"topic_id\"=\"enricher-bad\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 4,
        "yPos": 3
      },
      {
        "height": 3,
        "widget": {
          "title": "Currency Quota",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MIN",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MIN"
                    },
                    "filter": "metric.type=\"custom.googleapis.com/opencensus/gametuner_enricher/currency_api_quota_left\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 4,
        "xPos": 8
      },
      {
        "height": 6,
        "widget": {
          "collapsibleGroup": {
            "collapsed": false
          },
          "title": "Event Errors"
        },
        "width": 12
      },
      {
        "height": 3,
        "widget": {
          "title": "Event Errors",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "3600s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "3600s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"app_id\"",
                        "metric.label.\"event_name\"",
                        "metric.label.\"error\""
                      ],
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"custom.googleapis.com/opencensus/gametuner_enricher/event_errors\" resource.type=\"gce_instance\" $${app_id} $${event_name} $${error}",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 4,
        "xPos": 4,
        "yPos": 3
      },
      ${module.dashboard_vm.json},
      ${module.dashboard_cloudsql.json}
    ]
  }
}
EOF
}


