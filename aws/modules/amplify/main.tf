resource "aws_amplify_app" "application" {
  name         = var.app_name
  repository   = var.app_repo
  access_token = var.repo_oauth_token
}

resource "aws_amplify_branch" "amplify_branch" {
  app_id      = aws_amplify_app.application.id
  branch_name = var.prod_branch_name
}

resource "aws_amplify_branch" "amplify_branch_dev" {
  for_each               = { for idx, branch in var.non_prod_branches : idx => branch }
  app_id                 = aws_amplify_app.application.id
  branch_name            = each.value.branch_name
  enable_basic_auth      = each.value.enable_basic_auth
  basic_auth_credentials = each.value.enable_basic_auth ? base64encode(each.value.basic_auth_credentials) : null
}

resource "aws_amplify_domain_association" "domain_association" {
  app_id                = aws_amplify_app.application.id
  domain_name           = var.domain_name
  wait_for_verification = false

  sub_domain {
    branch_name = aws_amplify_branch.amplify_branch.branch_name
    prefix      = ""
  }

  dynamic "sub_domain" {
    for_each = var.non_prod_branches
    content {
      branch_name = sub_domain.value.branch_name
      prefix      = sub_domain.value.domain_prefix
    }
  }
}
