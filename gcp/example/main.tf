provider "google" {
  project = "<project-id>"
  region  = "<region>"
}

provider "google-beta" {
  project = "<project-id>"
  region  = "<region>"
}

module "gcp_website" {
  source = "github.com/sepehrjavid/static-website-provisioner/gcp/modules/static-website?ref=main"
  github_config = {
    access_token        = "1234"
    repo_uri            = "https://github.com/myrepo.git"
    app_installation_id = "1234"
  }
  branches = ["dev", "main"] # list of branches to be deployed
  dns_config = {
    domain_name    = "example.com"
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
