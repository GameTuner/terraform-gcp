locals {
  billing_account = "<billing-account-id>"
  org_id          = "<organization-id>"
}

# module "infra-production" {
#   source          = "./modules/gametuner_infra"
#   billing_account = local.billing_account
#   project_id      = "<gcp-project-id>"
#   project_name    = "<gcp-project-name>"
#   org_id          = local.org_id
# }