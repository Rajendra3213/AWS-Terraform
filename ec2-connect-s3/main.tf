terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  tags     = var.tags
}

module "subnet1" {
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = var.subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_name       = "${var.vpc_name}-subnet1"
  tags              = var.tags
}

module "subnet2" {
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = var.subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_name       = "${var.vpc_name}-subnet2"
  tags              = var.tags
}

module "ec2_sg" {
  source      = "../modules/security-group"
  name        = "${var.vpc_name}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  ]
  
  tags = var.tags
}

module "connect_sg" {
  source      = "../modules/security-group"
  name        = "${var.vpc_name}-connect-sg"
  description = "Security group for EC2 Instance Connect endpoint"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = []
  
  tags = var.tags
}

resource "aws_security_group_rule" "ec2_https_out" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ec2_sg.security_group_id
}

resource "aws_security_group_rule" "connect_ssh_out" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ec2_sg.security_group_id
  security_group_id        = module.connect_sg.security_group_id
}

module "ec2_role" {
  source      = "../modules/iam-role"
  role_name   = "${var.vpc_name}-ec2-role"
  policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  tags        = var.tags
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.subnet2.subnet_id
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  iam_instance_profile   = module.ec2_role.instance_profile_name
  
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-ec2"
  })
}

module "connect_endpoint" {
  source             = "../modules/ec2-connect-endpoint"
  subnet_id          = module.subnet1.subnet_id
  security_group_ids = [module.connect_sg.security_group_id]
  tags               = var.tags
}

module "s3_endpoint" {
  source           = "../modules/vpc-endpoint"
  vpc_id           = module.vpc.vpc_id
  service_name     = "com.amazonaws.${var.aws_region}.s3"
  endpoint_type    = "Gateway"
  route_table_ids  = [module.subnet2.route_table_id]
  tags             = var.tags
}