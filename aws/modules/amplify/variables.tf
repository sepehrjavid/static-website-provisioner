variable "app_name" {
  type = string
}

variable "app_repo" {
  type = string
}

variable "repo_oauth_token" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "prod_branch_name" {
  type = string
}

variable "non_prod_branches" {
  type = list(
    object({
      branch_name            = string
      domain_prefix          = string
      enable_basic_auth      = bool
      basic_auth_credentials = optional(string, null)
    })
  )

  validation {
    condition = alltrue([
      for branch in var.non_prod_branches :
      branch.enable_basic_auth == false || (branch.enable_basic_auth == true && branch.basic_auth_credentials != null && branch.basic_auth_credentials != "")
    ])
    error_message = "If enable_basic_auth is true, basic_auth_credentials must be provided and cannot be an empty string."
  }
}
