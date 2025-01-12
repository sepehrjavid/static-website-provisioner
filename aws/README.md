# AWS Static Website Module 
This repository provides a Terraform module for deploying a static website on AWS.

## Prerequisites

### Install Terraform

To install Terraform for your specific operating system, visit:

``https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli``

### Create Terraform Project
1. Run the following commands to create a new directory and navigate to it: 

```
mkdir my-website-resources && cd my-website-resources
```

2. Create a file named ``main.tf``in your directory and copy the content from the ``main.tf`` file located in the example directory.

3. Adjust the configuration parameters in ``main.tf`` to match your specific requirements and the details of your website repository.

4. Run the following command to initialize Terraform:
```
terraform init
```

5. Deploy your resources by executing:

```
terraform apply
```