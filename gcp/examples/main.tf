provider "google" {
  project = "vpns-447820"
  region  = "europe-north1"
}

provider "google-beta" {
  project = "vpns-447820"
  region  = "europe-north1"
}

module "gcp_website" {
  source        = "../modules/static-website"
  github_config = var.github_config
  branches      = ["dev", "main"]
  dns_config = {
    domain_name = "sepehrjavid.com"
  }
}
