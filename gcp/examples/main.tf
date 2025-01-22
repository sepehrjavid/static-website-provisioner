provider "google" {
  project = ""
}

provider "google-beta" {
  project = ""
}


module "gcp_website" {
  source                     = "../modules/static-website"
  region                     = "europe-north1"
  github_access_token        = "token"
  github_app_installation_id = "124"
  github_repo_uri            = "https://github.com"
  branches                   = ["dev", "main"]
}
