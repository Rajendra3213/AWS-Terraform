terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "security_group" {
  source      = "../modules/security-group"
  name        = var.security_group_name
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id
  ingress_rules = var.ingress_rules
  tags = var.tags
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[0]
  default_for_az    = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "main" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = data.aws_subnet.default.id
  
  tags = {
    Name = "Deploy"
  }
}




