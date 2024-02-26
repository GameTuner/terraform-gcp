module "dashboard_loadbalancer" {
  source     = "../../dashboard_templates/dashboard_loadbalancer"
  service = local.service
  offset = 0
  internal = false
}

module "dashboard_vm" {
  source     = "../../dashboard_templates/dashboard_vm"
  service = local.service
  offset = module.dashboard_loadbalancer.height
}

resource "google_monitoring_dashboard" "this" {
  lifecycle {
    ignore_changes = [
      dashboard_json
    ]
  }

  dashboard_json = <<EOF
{
  "dashboardFilters": [],
  "displayName": "${title(replace(local.service, "-", " "))}",
  "labels": {},
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      ${module.dashboard_loadbalancer.json},
      ${module.dashboard_vm.json}
    ]
  }
}
EOF
}


