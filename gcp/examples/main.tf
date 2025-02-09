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
    domain_name    = "sepehrjavid.com"
    set_dns_config = true
    zone_name      = "sepehrjavid-com"
  }
}

output "ip" {
  value = module.gcp_website.lb_ip
}

output "cert_auth" {
  value = module.gcp_website.dns_auth_creds
}
