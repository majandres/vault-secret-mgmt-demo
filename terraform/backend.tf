terraform {
  required_version = "~> 1.5"

  backend "s3" {
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.32.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
