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
    "title": "Load Balancer"
  },
  "width": 12,
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Requests",
    "xyChart": {
      "chartOptions": {
        "mode": "COLOR"
      },
      "dataSets": [
        {
          "minAlignmentPeriod": "60s",
          "plotType": "${var.display_requests_per_second ? "LINE" : "STACKED_BAR"}",
          "targetAxis": "Y1",
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "aggregation": {
                "alignmentPeriod": "60s",
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_${var.display_requests_per_second ? "RATE" : "SUM"}"
              },
              "filter": "metric.type=\"loadbalancing.googleapis.com/https/${var.internal ? "internal/" : ""}request_count\" resource.type=\"${var.internal ? "internal_http_lb_rule" : "https_lb_rule"}\" resource.label.\"backend_name\"=\"${var.service}-mig\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_${var.display_requests_per_second ? "MEAN" : "NONE"}"
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
    "title": "Errors",
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
  			  "groupByFields": [
  				"metric.label.\"response_code\""
  			  ],
  			  "perSeriesAligner": "ALIGN_MEAN"
  			},
  			"filter": "metric.type=\"loadbalancing.googleapis.com/https/${var.internal ? "internal/" : ""}request_count\" resource.type=\"${var.internal ? "internal_http_lb_rule" : "https_lb_rule"}\" metric.label.\"response_code_class\">=\"400\" resource.label.\"backend_name\"=\"${var.service}-mig\"",
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
    "title": "Latency 99th",
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
                "crossSeriesReducer": "REDUCE_PERCENTILE_99",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_DELTA"
              },
              "filter": "metric.type=\"loadbalancing.googleapis.com/https/${var.internal ? "internal/" : ""}total_latencies\" resource.type=\"${var.internal ? "internal_http_lb_rule" : "https_lb_rule"}\" resource.label.\"backend_name\"=\"${var.service}-mig\"",
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
  "yPos": ${var.offset}
},
{
  "height": 3,
  "widget": {
    "title": "Response size 99th",
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
              "filter": "metric.type=\"loadbalancing.googleapis.com/https/${var.internal ? "internal/" : ""}response_bytes_count\" resource.type=\"${var.internal ? "internal_http_lb_rule" : "https_lb_rule"}\" resource.label.\"backend_name\"=\"${var.service}-mig\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "crossSeriesReducer": "REDUCE_PERCENTILE_99",
                "groupByFields": [],
                "perSeriesAligner": "ALIGN_MAX"
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
    "title": "Request size 99th",
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
              "filter": "metric.type=\"loadbalancing.googleapis.com/https/${var.internal ? "internal/" : ""}request_bytes_count\" resource.type=\"${var.internal ? "internal_http_lb_rule" : "https_lb_rule"}\" resource.label.\"backend_name\"=\"${var.service}-mig\"",
              "secondaryAggregation": {
                "alignmentPeriod": "60s",
                "crossSeriesReducer": "REDUCE_SUM",
                "groupByFields": [],
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
  "yPos": ${var.offset + 3}
}
EOF
}