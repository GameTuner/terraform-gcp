terraform {
  backend "gcs" {
    bucket = "<bucket-name-for-terraform-state>"
    prefix = "terraform/projects"
  }
}

provider "google" {

}

provider "google-beta" {

}