variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "ec2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ec2_ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "ec2_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
}

variable "src_ips" {
  description = "Source IPs to allow access"
  type        = list(string)
}
