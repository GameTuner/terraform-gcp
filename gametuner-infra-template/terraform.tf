terraform {
  backend "gcs" {
    bucket = "<bucket-name-for-terraform-state>"
    prefix = "terraform/production"
  }
}

terraform {
  required_providers {
    google-beta = {
      version = "~> 4.58.0"
    }

    google = {
      source = "hashicorp/google"
      version = "5.10.0"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

provider "google-beta" {
  project = local.project
  region  = local.region
}