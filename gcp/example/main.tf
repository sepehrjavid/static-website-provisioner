provider "google" {
  project = "<project-id>"
  region  = "<region>"
}

provider "google-beta" {
  project = "<project-id>"
  region  = "<region>"
}

module "gcp_website" {
  source  = "sepehrjavid/static-website/google"
  version = "1.1.0"
  cicd = {
    enable                = true
    build_config_filename = "mycloudbuild.yaml"
    github_config = {
      access_token        = "ghp_abcdef1234567890"
      app_installation_id = "1234567"
      repo_uri            = "https://github.com/example/app.git"
    }
  }
  branches = ["dev", "main"] # list of branches to be deployed
  dns_config = {
    set_dns_config = true
    zone_name      = "example-com"
  }
}

output "ip" {
  value = module.gcp_website.lb_ip
}

output "cert_auth" {
  value = module.gcp_website.dns_auth_creds
}
