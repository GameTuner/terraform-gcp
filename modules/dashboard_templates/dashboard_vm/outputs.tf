output "offset" {
  value = var.offset
}

output "height" {
  value = 6
}

output "json" {
  value = <<EOF
{
  "height": 6,
  "widget": {
    "collapsibleGroup": {
      "collapsed": false
    },
    "title": "Virtual Machine"
  },
  "width": 12,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Memory",
    "xyChart": {
      "chartOptions": {
        "mode": "COLOR"
      },
      "dataSets": [
        {
          "breakdowns": [],
          "dimensions": [],
          "measures": [],
          "minAlignmentPeriod": "60s",
          "plotType": "LINE",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN",
                "crossSeriesReducer": "REDUCE_MEAN",
                "groupByFields": ["metric.label.\"instance_name\""]
              },
              "filter": "metric.type=\"compute.googleapis.com/instance/memory/balloon/ram_used\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_NONE"
              }
            }
          }
        },
        {
          "breakdowns": [],
          "dimensions": [],
          "measures": [],
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
              "filter": "metric.type=\"compute.googleapis.com/instance/memory/balloon/ram_size\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "xPos": 4,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "CPU",
    "xyChart": {
      "chartOptions": {
        "mode": "COLOR"
      },
      "dataSets": [
        {
          "breakdowns": [],
          "dimensions": [],
          "measures": [],
          "minAlignmentPeriod": "60s",
          "plotType": "LINE",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "crossSeriesReducer": "REDUCE_MEAN",
                "groupByFields": ["metric.label.\"instance_name\""],
                "perSeriesAligner": "ALIGN_MAX"
              },
              "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Received bytes",
    "xyChart": {
      "chartOptions": {
        "mode": "COLOR"
      },
      "dataSets": [
        {
          "breakdowns": [],
          "dimensions": [],
          "measures": [],
          "minAlignmentPeriod": "60s",
          "plotType": "LINE",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_RATE"
              },
              "filter": "metric.type=\"compute.googleapis.com/instance/network/received_bytes_count\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN",
                "crossSeriesReducer": "REDUCE_MEAN",
                "groupByFields": ["metric.label.\"instance_name\""]
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
  "xPos": 4,
  "yPos": ${var.offset + 3}
},
{
  "height": 3,
  "widget": {
    "title": "Sent Bytes",
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
                "perSeriesAligner": "ALIGN_RATE"
              },
              "filter": "metric.type=\"compute.googleapis.com/instance/network/sent_bytes_count\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN",
                "crossSeriesReducer": "REDUCE_MEAN",
                "groupByFields": ["metric.label.\"instance_name\""]
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
  "yPos": ${var.offset + 3}
},
{
  "height": 6,
  "widget": {
    "timeSeriesTable": {
      "columnSettings": [
        {
          "column": "Name (from instance_id)",
          "visible": true
        },
        {
          "column": "value",
          "visible": true
        }
      ],
      "dataSets": [
        {
          "minAlignmentPeriod": "60s",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MIN"
              },
              "filter": "metric.type=\"compute.googleapis.com/instance/uptime_total\" resource.type=\"gce_instance\" metadata.user_labels.\"service\"=\"${var.service}\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_NONE"
              }
            }
          }
        }
      ],
      "metricVisualization": "NUMBER"
    },
    "title": "Uptime"
  },
  "width": 4,
  "xPos": 8,
  "yPos": ${var.offset}
}
EOF
}