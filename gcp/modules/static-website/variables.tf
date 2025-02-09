variable "branches" {
  type = set(string)
}

variable "github_config" {
  type = object({
    access_token        = string
    app_installation_id = string
    repo_uri            = string
  })
  sensitive = true
}

variable "enable_cicd" {
  type    = bool
  default = true
}

variable "enable_cdn" {
  type    = bool
  default = true
}

variable "enable_http_redirect" {
  type    = bool
  default = true
}

variable "default_branch_name" {
  type    = string
  default = "main"
}

variable "dns_config" {
  type = object({
    set_dns_config = optional(bool, false)
    zone_name      = optional(string, null)
    domain_name    = string
  })

  validation {
    condition     = !(var.dns_config.set_dns_config) || var.dns_config.zone_name != null
    error_message = "zone_name cannot be null when set_dns_config is set to true"
  }
}
