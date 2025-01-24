provider "google" {
  project = "vpns-447820"
  region  = "europe-north1"
}

provider "google-beta" {
  project = "vpns-447820"
  region  = "europe-north1"
}

module "gcp_website" {
  source                     = "../modules/static-website"
  github_access_token        = var.github_access_token
  github_app_installation_id = var.github_app_installation_id
  github_repo_uri            = var.github_repo_uri
  branches                   = var.branches
}
