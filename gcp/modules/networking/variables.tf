variable "enable_cdn" {
  type = bool
}

variable "enable_http_redirect" {
  type    = bool
  default = true
}

variable "dns_config" {
  type = object({
    set_dns_record = optional(bool, false)
    zone_name      = optional(string, null)
    domain_name    = string
  })
}

variable "branches" {
  type = set(string)
}

variable "website_buckets" {
  type = map(object({
    name = string
    id   = string
  }))
}

variable "default_branch_name" {
  type    = string
  default = "main"
}
