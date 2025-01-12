provider "aws" {
  region = "eu-north-1"
}

module "aws_amplify" {
  source           = "../modules/amplify"
  app_name         = "test_app"
  app_repo         = "https://github.com/example/test"
  repo_oauth_token = "test"
  domain_name      = "test.com"
  non_prod_branches = [
    {
      branch_name       = "staging"
      domain_prefix     = "stg"
      enable_basic_auth = false
    },
    {
      branch_name            = "develop"
      domain_prefix          = "dev"
      enable_basic_auth      = true
      basic_auth_credentials = base64encode("<username>:<password>")
    }
  ]
}
