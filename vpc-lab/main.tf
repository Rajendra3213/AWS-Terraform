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

module "vpc" {
  source   = "../modules/vpc"
  vpc_name = "main-vpc"
  tags     = var.tags
}

module "public_subnet" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  subnet_name             = "public-subnet"
  map_public_ip_on_launch = true
  tags                    = var.tags
}

module "private_subnet" {
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  subnet_name       = "private-subnet"
  tags              = var.tags
}

module "nat_gateway" {
  source           = "../modules/nat-gateway"
  public_subnet_id = module.public_subnet.subnet_id
  nat_name         = "main-nat"
  tags             = var.tags
}

resource "aws_route" "public_route" {
  route_table_id         = module.public_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.internet_gateway_id
}

resource "aws_route" "private_route" {
  route_table_id         = module.private_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_id
}

module "public_sg" {
  source      = "../modules/security-group"
  name        = "public-sg"
  description = "Security group for public instance"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
  tags = var.tags
}

module "private_sg" {
  source      = "../modules/security-group"
  name        = "private-sg"
  description = "Security group for private instance"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
    }
  ]
  
  tags = var.tags
}

module "public_ec2" {
  source            = "../modules/ec2-public"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_id = module.public_sg.security_group_id
  subnet_id         = module.public_subnet.subnet_id
  instance_name     = "public-instance"
  tags              = var.tags
}

module "private_ec2" {
  source            = "../modules/ec2-private"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_id = module.private_sg.security_group_id
  subnet_id         = module.private_subnet.subnet_id
  instance_name     = "private-instance"
  tags              = var.tags
}