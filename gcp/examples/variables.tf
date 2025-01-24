variable "github_repo_uri" {
  type = string
}

variable "github_access_token" {
  type      = string
  sensitive = true
}

variable "github_app_installation_id" {
  type = string
}

variable "branches" {
  type = set(string)
}
