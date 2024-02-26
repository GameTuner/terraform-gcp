module "dashboard_loadbalancer" {
  source     = "../../dashboard_templates/dashboard_loadbalancer"
  service = local.service
  offset = 0
}

module "dashboard_vm" {
  source     = "../../dashboard_templates/dashboard_vm"
  service = local.service
  offset = module.dashboard_loadbalancer.height
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
  "dashboardFilters": [],
  "displayName": "${title(replace(local.service, "-", " "))}",
  "labels": {},
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      ${module.dashboard_loadbalancer.json},
      ${module.dashboard_vm.json},
      ${module.dashboard_cloudsql.json}
    ]
  }
}
EOF
}


