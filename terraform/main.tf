module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.vpc_name

  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  default_security_group_name = "default"
  tags = {
    "Terraform" : "true"
    "Project" : "vault-secret-mgmt-demo"
  }
}

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.6.0"

#   name = var.ec2_name
#   ami  = var.ec2_ami

#   instance_type               = var.ec2_instance_type
#   key_name                    = var.ec2_key_name
#   monitoring                  = false
#   vpc_security_group_ids      = [aws_security_group.minikube.id]
#   subnet_id                   = module.vpc.public_subnets[0]
#   associate_public_ip_address = true
#   root_block_device = [
#     {
#       volume_size = 50
#       volume_type = "gp3"
#     }
#   ]
#   user_data_base64 = filebase64("userdata.sh")

#   tags = {
#     Terraform = "true"
#     Name      = var.ec2_name
#     Project   = "vault-secret-mgmt-demo"
#   }
# }

# resource "aws_security_group" "minikube" {
#   name   = var.ec2_name
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     description = "Web"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = var.src_ips
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description = "AltWeb"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = var.src_ips
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description = "NodePorts"
#     from_port   = 30000
#     to_port     = 32767
#     protocol    = "tcp"
#     cidr_blocks = var.src_ips
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description = "Secure web"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = var.src_ips
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.src_ips
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Terraform = "true"
#     Name      = var.ec2_name
#     Project   = "vault-secret-mgmt-demo"
#   }
# }
