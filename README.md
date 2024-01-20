# Secret Management with HashiCorp Vault

## Required Tools
* terraform
* tflint
* [pre-commit](https://pre-commit.com/)

## Infrastructure Setup
To run this demo, we will use terraform to deploy the required infrastructure components such as VPC, Networking, EC2 machine, etc.  Note that the terraform code is specific to AWS.

Before creating these infrastructure components, let's first create the S3 bucket which will contain the terraform state for these components.
1. Navigate to the `./terraform/remote-state` directory.
2. Run terraform init/plan/apply commands to set up the remote state.

Afterwards, navigate to the `./terraform` directory where the required infrastructure can now be provisioned.
1. `terraform init -reconfigure -backend-config=config/backend-demo.conf`
2. `terraform plan -var-file=config/demo.tfvars -out=test`
