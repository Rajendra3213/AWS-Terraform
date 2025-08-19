# AWS VPC Architecture with Terraform

A modular Terraform configuration that creates a complete AWS VPC architecture with public and private subnets, NAT Gateway, and EC2 instances.

## Architecture

This project creates:
- VPC with DNS support
- Public subnet with Internet Gateway access
- Private subnet with NAT Gateway access
- Security groups for public and private instances
- EC2 instances in both subnets

## Prerequisites

- AWS CLI configured or AWS credentials
- Terraform >= 1.0
- An existing EC2 Key Pair in your AWS account

## Quick Start

1. Clone and navigate to the project:
```bash
cd vpc-architecture
```

2. Copy and configure variables:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with your AWS credentials and settings:
```hcl
access_key = "your-access-key"
secret_key = "your-secret-key"
region     = "us-east-1"
key_name   = "your-key-pair-name"
```

4. Deploy the infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

## Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `access_key` | AWS Access Key | "" |
| `secret_key` | AWS Secret Key | "" |
| `region` | AWS Region | "us-east-1" |
| `ami_id` | AMI ID for EC2 instances | "ami-020cba7c55df1f615" |
| `instance_type` | EC2 instance type | "t2.micro" |
| `key_name` | EC2 Key Pair name | "vpc-key" |

### Network Configuration

- VPC CIDR: `10.0.0.0/16`
- Public Subnet: `10.0.1.0/24` (us-east-1a)
- Private Subnet: `10.0.2.0/24` (us-east-1b)

## Modules

- `vpc` - Creates VPC and Internet Gateway
- `subnet` - Creates subnets with route tables
- `nat-gateway` - Creates NAT Gateway with Elastic IP
- `security-group` - Creates security groups with rules
- `ec2-public` - Creates public EC2 instance
- `ec2-private` - Creates private EC2 instance

## Security

- Public instance: SSH access from anywhere (0.0.0.0/0)
- Private instance: SSH access only from public subnet (10.0.1.0/24)
- All egress traffic allowed

## Cleanup

```bash
terraform destroy
```

## Notes

- Ensure your key pair exists in the specified region
- NAT Gateway incurs charges even when idle
- Default AMI is Amazon Linux 2 for us-east-1