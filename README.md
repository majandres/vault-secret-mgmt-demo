# Secret Management with HashiCorp Vault

## Required Tools
* terraform
* tflint
* [pre-commit](https://pre-commit.com/)
* minikube
* helm

## Infrastructure Setup
To run this demo, we will use terraform to deploy the required infrastructure components such as VPC, Networking, EC2 machine, etc.  Note that the terraform code is specific to AWS.

Before creating these infrastructure components, it's recommended to create an S3 bucket which will contain the terraform state for these components.  Checkout the `remote-state-s3-backend` [module](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws/latest).

Create configuration files under the `./terraofrm/config` directory.  See examples below.

backend-demo.conf
```
bucket         = "<s3_bucket_name>"
key            = "<s3_bucket_key>"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "<dynamodb_table>"
```

demo.tfvars
```
vpc_name            = "<vpc_name>"
vpc_cidr            = "10.10.0.0/16"
vpc_azs             = ["us-east-1a", "us-east-1b"]
vpc_public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
vpc_private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24"]

ec2_name          = ""
ec2_ami           = "ami-01234567891234567"
ec2_instance_type = "t3.medium"
ec2_key_name      = ""
src_ips           = []
```

Afterwards, navigate to the `./terraform` directory where the required infrastructure can now be provisioned.
1. `terraform init -reconfigure -backend-config=config/backend-demo.conf`
2. `terraform plan -var-file=config/demo.tfvars -out=test`
