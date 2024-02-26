# GameTuner Terraform GCP
  
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)][license]


## Project Overview

GameTuner Terraform GCP is a set of terraform environments and modules to create and manage GCP resources for GameTuner project.

## Requirements

### Prerequisites

- [Terraform][terraform] - 1.3.7+
- [gcloud CLI][gcloud-cli] - 412.0.0+

## Setup

In order to use this project, you need to have a GCP account.

### Create GCP organisation and billing account

-  First create organisation and billing account on GCP. More info you can find [here][gcp-organisation].
- In IAM section of the organisation, for user that will run terraform commands, add roles `Folder Admin`, `Project Mover` and `Project Creator`.
- Create a new project and enable billing for it. You will use this project for creating resources for GameTuner. For exampe, name it `YOUR_COMPANY_NAME-terraform`. You will use this project for terraform state and lock objects.
- In created project create bucket storage. Name it like `YOUR_COMPANY_NAME-terraform-state`. This bucket will be used for storing terraform state and lock objects.

### Configure gcloud CLI

- Run `gcloud init` and follow the instructions to authenticate and configure the gcloud CLI.
- Run `gcloud config set project YOUR_COMPANY_NAME-terraform` to set the project you created for terraform state and lock objects.
- Run `gcloud auth application-default login` to authenticate with application default credentials.

### Create project for GameTuner resources

Module `infra-projects` creates projects and enables GCP services. It is meant to be run first as those services are enabled asynchronously and may cause other resources to fail.

- in [`terraform.tf`][infra-project-bucket] setup terraform.backend.bucket to the name of the bucket you created for terraform state and lock objects.
- in [`main.tf`][infra-project-main] uncomment module `infra-production` and setup next variables:
  - `billing_account` - id of the billing account you created
  - `org_id` - id of the organisation you created. You can find it in GCP console in IAM section of the organisation, read [here][organisation-id] how to find it.
  - `project_id` - id of the project that will be created for GameTuner resources. It should be unique in GCP. For example `YOUR_COMPANY_NAME-infra-production`.
  - `project_name` - name of the project that will be created for GameTuner resources. For example `YOUR_COMPANY_NAME Production`.

Once you have set up the project, go to `infra-projects` folder and run `terraform init`. After initialization run `terraform apply` in `infra-projects` folder. It will ask you to confirm the changes. After confirmation it will create a new project and enable GCP services.

### Deploy GameTuner resources

After you have created project for GameTuner resources, you can deploy GameTuner resources. You can deploy all resources at once or you can deploy them one by one. 

Follow next steps to deploy all resources at once:

- Copy folder `gametuner-intra-template` into the root of the project and rename it, for example to `YOUR_COMPANY_NAME-infra-production`. 
- in `terraform.tf` setup terraform.backend.bucket to the name of the bucket you created for terraform state and lock objects.
- In `main.tf` file of the copied folder, insite `locals` block, setup next variables:
  - `project` (**required**) - id of the project that you created for GameTuner resources.
  - `project_name` (**required**) - name of the project that you created for GameTuner resources.
  - `region` (**required**) - region where you want to create resources. For example `europe-west1`.
  - `distribution_zones` (**required**) - list of distribution zones where you want to create resources. For example `["europe-west1-b", "europe-west1-c", "europe-west1-d"]`.
  - `bq_datasets_location` (**required**) - location where you want to create BigQuery datasets. For example `EU`.
  - `billing_account` (**required**) - id of the billing account you created
  - `github_token_secret_id` (**required**) - you need to setup GitHub token, that will be used for cloning all repositories and make them accessable for Cloud Build. You can create a new token in GitHub and use it here. Read more about how to create a token [here][github-token]. Change the name of the secret that you will create in Secret Manager, for example `github-token`.
  - `github_token_secret_value` (**required**) - value of the token that you created in GitHub.
  - `alerting_notification_channels` (optional) - list of notification channels that will be used for alerting. For example `["projects/YOUR_COMPANY_NAME-infra-production/notificationChannels/1234567890"]`. You can create notification channels in GCP console in Monitoring section. Read more about how to create notification channels [here][gcp-notification-channels]. To list all available channels run command `gcloud beta monitoring channels list`. You can leave it empty if you don't want to setup alerting.
  - `custom_collector_domain` (optional) - domain that will be used for collector. For example `data.YOUR_COMPANY_NAME.com`. If you use custom domain, you need to setup DNS records for it. After terraform apply, you will get IP address of collector application that you need to use for A record. If you don't want to use custom domain, you can leave it empty and it will use default domain over http protocol.
  - `etl_currency_api_key` (optional) - API key that will be used for currency conversion in ETL service. You can get it from [here][currency-conversion-service]. If you don't want to use currency conversion, you can leave it empty.
  - `etl_slack_webhook_url` (optional) - Slack webhook url that will be used for sending messages from ETL service. You can create a new webhook in Slack and use it here. If you don't want to use Slack, you can leave it empty. More about how to create a webhook in Slack you can find [here][slack-webhook].
  - `maxmind_licence_key` (optional) - licence key that will be used for MaxMind service. You can get it from MaxMind. If you don't want to use MaxMind, you can leave it empty. Default GeoIP database will be used that is deployed with the application.
  - `openexchangerates_licence_key` (optional) - licence key that will be used for OpenExchangeRates service. You can get it from OpenExchangeRates. In GameTuner Enricher project we implemented currency enricment that uses api from https://openexchangerates.org/. If you don't want to use this enricment, you can leave it empty.
  - `cloud_build_slack_webhook_url` (optional) - Slack webhook url that will be used for sending messages from Cloud Build. You can leave it empty if you don't want to use Slack webhook.
  - `client_projects` (optional) - list of client projects that will be created for creating resources for clients. By default it will be created one client project. 

***Note***: If you fork projects of all GameTuner components, you will need to change `repository_url` in `main.tf` file of each component to your repository url. By default repository urls are set to public repositories of GameTuner components.

Once you have set up the project, go to the folder and run next commands

```bash
gcloud config set project <PROJECT_ID>
gcloud auth application-default login
terraform init
terraform apply
```

It will ask you to confirm the changes. After confirmation it will create all resources for GameTuner.

## Licence

The GameTuner Terraform GCP is copyright 2022-2024 AlgebraAI.

GameTuner Terraform GCP is released under the [Apache 2.0 License][license].

[terraform]:https://developer.hashicorp.com/terraform/install
[gcloud-cli]:https://cloud.google.com/sdk/gcloud
[gcp-organisation]:https://cloud.google.com/billing/docs/how-to/create-billing-account
[infra-project-bucket]:infra-projects/terraform.tf
[infra-project-main]:infra-projects/main.tf
[organisation-id]:https://cloud.google.com/resource-manager/docs/creating-managing-organization#retrieving_your_organization_id
[github-token]:https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
[gcp-notification-channels]:https://cloud.google.com/monitoring/support/notification-options
[currency-conversion-service]:https://openexchangerates.org/
[slack-webhook]:https://api.slack.com/messaging/webhooks
[license]:https://www.apache.org/licenses/LICENSE-2.0
