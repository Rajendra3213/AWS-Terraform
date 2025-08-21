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

module "nat_gateway" {
  source           = "../modules/nat-gateway"
  public_subnet_id = module.public_subnet.subnet_id
  nat_name         = "${var.vpc_name}-nat"
  tags             = var.tags
}

resource "aws_route" "private_nat" {
  route_table_id         = module.private_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_id
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

resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "app_key" {
  key_name   = "${var.vpc_name}-key-new"
  public_key = tls_private_key.app_key.public_key_openssh
}

resource "local_file" "app_private_key" {
  content         = tls_private_key.app_key.private_key_pem
  filename        = "${path.root}/${var.vpc_name}-key-new.pem"
  file_permission = "0400"
}

resource "aws_instance" "app" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.public_subnet.subnet_id
  
  user_data = <<-EOF
    #!/bin/bash
    echo "nameserver 169.254.169.253" > /etc/resolv.conf
    echo "search ${var.domain_name}" >> /etc/resolv.conf
    systemctl restart systemd-resolved
  EOF
  
  tags = merge(var.tags, {
    Name = "app"
  })
}

resource "aws_instance" "db" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.private_subnet.subnet_id
  
  user_data = <<-EOF
    #!/bin/bash
    echo "nameserver:69.253" > /etc/resolv.conf
    echo "search ${var.domain_name}" >> /etc/resolv.conf
    systemctl restart systemd-resolved
  EOF
  
  tags = merge(var.tags, {
    Name = "db"
  })
}

module "route53" {
  source      = "../modules/route53"
  domain_name = var.domain_name
  vpc_id      = module.vpc.vpc_id
  
  dns_records = {
    "app.${var.domain_name}" = aws_instance.app.private_ip
    "db.${var.domain_name}"  = aws_instance.db.private_ip
  }
  
  tags = var.tags
}