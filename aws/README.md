
# AWS Static Website Module

This Terraform module helps you deploy a static website on AWS seamlessly.

**Note:** Cloning this repository is not required to use the module.

## Prerequisites

Before you begin, ensure the following:

1. You have a static website project hosted on GitHub.
2. You have access to an AWS account with a user having sufficient permissions.
3. A domain resgistered in AWS route53. [Register a domain](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html)

## Setup Instructions

### 1. Install Terraform

Follow the official [Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to set up Terraform for your operating system.

### 2. Create a Terraform Project

1. Create and navigate to a new directory for your Terraform project:
   ```bash
   mkdir my-website-resources && cd my-website-resources
   ```

2. Create a `main.tf` file in the directory and copy the content from the `example/main.tf` file of this module.

3. Customize the configuration in `main.tf` to fit your requirements, such as website repository details and parameters.

4. Initialize Terraform in your project directory:
   ```bash
   terraform init
   ```

5. Apply the Terraform configuration to deploy your resources:
   ```bash
   terraform apply
   ```

Important note: Please note that in order to be able to modify your resources later, you must NOT remove or modify the terraform state file automatically created in this directory. Otherwise you will have to destroy the resources mannually. (Cloud based state file will come soon to this module.)

## Input Variables

You can configure the module using the following variables:

| Variable               | Type            | Description                                                                                      | Example                                      |
|------------------------|-----------------|--------------------------------------------------------------------------------------------------|----------------------------------------------|
| `app_name`             | `string`       | The name of your application.                                                                   | `"my-app"`                                   |
| `app_repo`             | `string`       | The GitHub repository URL of your application.                                                  | `"https://github.com/example/app"`           |
| `repo_oauth_token`     | `string`       | OAuth token for accessing the repository. Refer to [GitHub Token Guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). | `"ghp_abcdef1234567890"`                     |
| `domain_name`          | `string`       | The domain name for hosting the website.                                                        | `"example.com"`                              |
| `prod_branch_name`     | `string`       | The name of the production branch in your GitHub repository.                                     | `"main"`                                     |
| `non_prod_branches`    | `list(object)` | List of non-production branch details. See the structure and table below.                       | See example below.                           |

### Non-Production Branch Object Structure

Each object in the `non_prod_branches` list should follow this format:

```hcl
{
  branch_name            = string       
  domain_prefix          = string       
  enable_basic_auth      = bool         
  basic_auth_credentials = optional(string, null)
}
```

### Non-Production Branch Variables

The following table explains the sub-variables for `non_prod_branches`:

| Variable                 | Type            | Description                                                                                   | Example           |
|--------------------------|-----------------|-----------------------------------------------------------------------------------------------|-------------------|
| `branch_name`            | `string`       | The name of the branch.                                                                       | `"develop"`   |
| `domain_prefix`          | `string`       | A domain prefix to distinguish environments.                                                  | `"dev"`       |
| `enable_basic_auth`      | `bool`         | Whether to enable basic authentication for the branch.                                        | `true`            |
| `basic_auth_credentials` | `string, null` | Optional credentials for basic authentication. Set to `null` if not required.                | `"username:password"` |

---

Note: If `enable_basic_auth` is set to `false`,  `basic_auth_credentials` is not required anymore.

## Destroy Instructions
Simply move to the direcory you created in the setup section and perform terraform destroy command:

```bash
cd my-website-resources && terraform destroy
```