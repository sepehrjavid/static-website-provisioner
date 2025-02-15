# GCP Static Website Module

This Terraform module helps you deploy a static website on GCP seamlessly.

**Note:** Cloning this repository is not required to use the module.

## Prerequisites

Before you begin, ensure the following:

1. You have a static website project hosted on GitHub.
2. You have access to a GCP account with a user having sufficient permissions.
3. A registered domain. The registrar does not have to be GCP however, preferred.

## Setup Instructions

### 1. Install Terraform

Follow the official [Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to set up Terraform for your operating system.

### 2. Create a Terraform Project

1. Create and navigate to a new directory for your Terraform project:
   ```bash
   mkdir my-website-resources && cd my-website-resources
   ```

2. Create a `main.tf` file in the directory and copy the content from the `example/main.tf` file of this module.

3. Customize the configuration in `main.tf` to fit your requirements, such as website repository details and parameters. Additionally, fill in the project id and the region you want to use to deploy your resources.

4. Initialize Terraform in your project directory:
   ```bash
   terraform init
   ```

5. Apply the Terraform configuration to deploy your resources:
   ```bash
   terraform apply
   ```

Important note: Please note that in order to be able to modify your resources later, you must NOT remove or modify the Terraform state file automatically created in this directory. Otherwise, you will have to destroy the resources manually. (Cloud-based state file will come soon to this module.)

## Input Variables

You can configure the module using the following variables:

| Variable               | Type            | Description                                                                                      | Default       | Example                                      |
|------------------------|----------------|------------------------------------------------------------------------------------------------|---------------|----------------------------------------------|
| `branches`            | `set(string)`   | Set of branch names that need deployment.                                                     | None       | `[ "main", "develop" ]`                   |
| `github_config`       | `object`        | GitHub configuration details.                                                                 | None       | See structure below.                           |
| `enable_cicd`         | `bool`          | Enables CI/CD for automated deployments.                                                      | None       | `true`                                       |
| `enable_cdn`         | `bool`          | Enables Cloud CDN for better performance.                                                     | `true`       | `true`                                       |
| `enable_http_redirect`| `bool`          | Enables HTTP to HTTPS redirection.                                                            | `true`       | `true`                                       |
| `default_branch_name` | `string`        | The name of the default production branch.                                                   | `"main"`       | `"main"`                                    |
| `dns_config`         | `object`        | Configuration for DNS settings.                                                              | None       | See structure below.                           |



**Note: The varibales with default value of `None` are required.**

### GitHub Configuration Object Structure

Each `github_config` object consists of the following variables:

| Variable               | Type            | Description                                                                                      | Default       | Example                                      |
|------------------------|----------------|------------------------------------------------------------------------------------------------|---------------|----------------------------------------------|
| `access_token`            | `string`   | GitHub access token                                                     | None       | `ghp_************************************`                   |
| `app_installation_id`       | `string`        | GitHub App installation                                                                 | None       | `https://github.com/my_repo.git`                           |
| `repo_uri`         | `string`          | Repository URI                                                       | None       | `12345678`                                       |


### DNS Configuration Object Structure

Each `dns_config` object consists of the following variables:

| Variable               | Type            | Description                                                                                      | Default       | Example                                      |
|------------------------|----------------|------------------------------------------------------------------------------------------------|---------------|----------------------------------------------|
| `set_dns_config`            | `bool`   |  Whether to configure DNS settings.                                                     | `false`       | `true`                   |
| `zone_name`       | `string`        |  DNS Zone Name (If created in GCP) (Required if `set_dns_config` is true).                                                                 | None       | `example-com`                           |
| `domain_name`         | `string`          | Domain Name for the website.                                                       | None       | `example.com`                                       |

### Example Values

```hcl
branches = ["main", "develop"]

github_config = {
  access_token        = "ghp_abcdef1234567890"
  app_installation_id = "1234567"
  repo_uri            = "https://github.com/example/app"
}

enable_cicd = true
enable_cdn = true
enable_http_redirect = true
default_branch_name = "main"

dns_config = {
  set_dns_config = true
  zone_name      = "example-zone"
  domain_name    = "example.com"
}
```

### More on DNS

The `dns_config` block controls DNS settings.  The `set_dns_config` variable determines the configuration method:

- Manual DNS (`set_dns_config` = `false` - Default): The module outputs the website's IP address and DNS challenge records for TLS verification. You are responsible for creating the necessary DNS records with your provider.
- Automated DNS (`set_dns_config` = `true`): Provide the `zone_name` of your Cloud DNS zone. The module automatically creates all required DNS records, including those for TLS certificate verification.

TLS certificate verification may take some time.



## Destroy Instructions
Simply move to the directory you created in the setup section and perform the Terraform destroy command:

```bash
cd my-website-resources && terraform destroy
```