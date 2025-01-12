# AWS Static Website Module 
This repository provides a terraform module to deploy a website on AWS.

## Prerequisites

### Install Terraform

In order to install terraform according to your machine type, please refer to:

``https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli``

### Create Terraform Project
1. First create a directory: 

```
mkdir my-website-resources && cd my-website-resources
```

2. Create a file called ``main.tf`` and copy the content of ``main.tf`` under the example directory in your ``main.tf``

3. Modify the parameters based on your requirements and website repository

4. Initialize terraform:

```
terraform init
```

5. Apply terraform code:

```
terraform apply
```