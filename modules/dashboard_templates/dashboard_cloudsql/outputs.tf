output "offset" {
  value = var.offset
}

output "height" {
  value = 9
}

output "json" {
  value = <<EOF
{
  "height": 12,
  "widget": {
    "collapsibleGroup": {
      "collapsed": false
    },
    "title": "CloudSQL"
  },
  "width": 12,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Query duration",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/insights/aggregate/execution_time\" resource.type=\"cloudsql_instance_database\" resource.label.\"database\"=\"postgres\" resource.label.\"resource_id\"=\"${var.project}:${var.service}-db\"",
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
    "title": "Lock time",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/insights/aggregate/lock_time\" resource.type=\"cloudsql_instance_database\" resource.label.\"database\"=\"postgres\" resource.label.\"resource_id\"=\"${var.project}:${var.service}-db\"",
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
  "yPos": ${var.offset + 6}
},
{
  "height": 3,
  "widget": {
    "title": "Deadlocks",
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
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/deadlock_count\" resource.type=\"cloudsql_database\" metric.label.\"database\"=\"postgres\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "yPos": ${var.offset + 9}
},
{
  "height": 3,
  "widget": {
    "title": "Transactions",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/transaction_count\" resource.type=\"cloudsql_database\" metric.label.\"database\"=\"postgres\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Inserts/Updates",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/tuples_processed_count\" resource.type=\"cloudsql_database\" metric.label.\"database\"=\"postgres\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "xPos": 4,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Number of rows",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/tuple_size\" resource.type=\"cloudsql_database\" metric.label.\"database\"=\"postgres\" metric.label.\"tuple_state\"=\"live\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
    "title": "Connections",
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
              "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" resource.type=\"cloudsql_database\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
    "title": "Disk Utilization",
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
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
  "yPos": ${var.offset + 6}
},
{
  "height": 3,
  "widget": {
    "title": "Memory Utilization",
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
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
          "minAlignmentPeriod": "60s",
          "plotType": "LINE",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN"
              },
              "filter": "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"service\"=\"${var.service}\"",
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
}
EOF
}