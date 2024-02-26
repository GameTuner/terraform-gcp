variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "github_token_secret_id" {
  type = string
}

variable "github_token_secret_value" {
  type = string
}

# Found in github, click cloudbuild app, installation id is in url
variable "github_cloudbuild_installation_id" {
  type = number
}