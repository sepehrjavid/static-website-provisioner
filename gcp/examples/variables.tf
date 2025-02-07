variable "github_config" {
  type = object({
    access_token        = string
    app_installation_id = string
    repo_uri            = string
  })
  sensitive = true
}
