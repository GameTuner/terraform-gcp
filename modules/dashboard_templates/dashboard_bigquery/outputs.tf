output "offset" {
  value = var.offset
}

output "height" {
  value = 9
}

output "json" {
  value = <<EOF
{
  "height": 9,
  "widget": {
    "collapsibleGroup": {
      "collapsed": false
    },
    "title": "BigQuery"
  },
  "width": 12,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Slots usage",
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
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/slots/allocated\" resource.type=\"bigquery_project\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_NONE"
              }
            }
          }
        },
        {
          "minAlignmentPeriod": "60s",
          "plotType": "LINE",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/slots/total_available\" resource.type=\"global\"",
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
    "title": "Concurrent queries",
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
          "plotType": "STACKED_BAR",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_SUM"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/query/count\" resource.type=\"global\"",
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
  "yPos": ${var.offset + 6}
},
{
  "height": 3,
  "widget": {
    "title": "Query duration 99th",
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
                "perSeriesAligner": "ALIGN_PERCENTILE_99"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/query/execution_times\" resource.type=\"global\"",
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
        "label": "",
        "scale": "LINEAR"
      }
    }
  },
  "width": 4,
  "xPos": 8,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Scanned bytes billed",
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
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/query/scanned_bytes_billed\" resource.type=\"global\"",
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
  "yPos": ${var.offset + 3}
},
{
  "height": 3,
  "widget": {
    "title": "Scanned bytes",
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
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/query/scanned_bytes\" resource.type=\"global\"",
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
  "yPos": ${var.offset + 3}
},
{
  "height": 3,
  "widget": {
    "title": "Query count",
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
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/query/execution_count\" resource.type=\"bigquery_project\"",
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
    "title": "Stored bytes",
    "xyChart": {
      "chartOptions": {
        "mode": "COLOR"
      },
      "dataSets": [
        {
          "minAlignmentPeriod": "86400s",
          "plotType": "STACKED_BAR",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "86400s",
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [
                  "resource.label.\"dataset_id\""
                ],
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"bigquery.googleapis.com/storage/stored_bytes\" resource.type=\"bigquery_dataset\" resource.label.\"dataset_id\"!=monitoring.regex.full_match(\"_script.*\")",
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
  "xPos": 8,
  "yPos": ${var.offset + 3}
}
EOF
}