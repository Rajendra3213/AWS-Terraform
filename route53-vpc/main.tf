terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
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

# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]
  
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  tags     = var.tags
}

module "dhcp_options" {
  source      = "../modules/dhcp-options"
  domain_name = var.domain_name
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
}

module "public_subnet" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  subnet_name             = "${var.vpc_name}-public"
  map_public_ip_on_launch = true
  tags                    = var.tags
}

module "private_subnet" {
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_name       = "${var.vpc_name}-private"
  tags              = var.tags
}

resource "aws_route" "public_internet" {
  route_table_id         = module.public_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.internet_gateway_id
}

module "security_group" {
  source      = "../modules/security-group"
  name        = "${var.vpc_name}-sg"
  description = "Security group for SSH and ICMP"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = [var.vpc_cidr]
    }
  ]
  
  tags = var.tags
}

module "app_instance" {
  source            = "../modules/ec2-public"
  ami_id            = "ami-020cba7c55df1f615"
  instance_type     = var.instance_type
  key_name          = "${var.vpc_name}-key"
  security_group_id = module.security_group.security_group_id
  subnet_id         = module.public_subnet.subnet_id
  instance_name     = "app"
  tags              = var.tags
}

module "db_instance" {
  source            = "../modules/ec2-private"
  ami_id            = "ami-020cba7c55df1f615"
  instance_type     = var.instance_type
  key_name          = "${var.vpc_name}-key"
  security_group_id = module.security_group.security_group_id
  subnet_id         = module.private_subnet.subnet_id
  instance_name     = "db"
  tags              = var.tags
}

module "route53" {
  source      = "../modules/route53"
  domain_name = var.domain_name
  vpc_id      = module.vpc.vpc_id
  
  dns_records = {
    "app.${var.domain_name}" = module.app_instance.private_ip
    "db.${var.domain_name}"  = module.db_instance.private_ip
  }
  
  tags = var.tags
}