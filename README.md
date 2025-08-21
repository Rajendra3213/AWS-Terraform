# AWS Terraform Infrastructure

This repository contains Terraform configurations for AWS infrastructure with reusable modules.

## Structure

```
├── modules/              # Reusable Terraform modules
├── EC2/                  # Simple EC2 instance deployment
├── vpc-architecture/     # VPC with public/private subnets and NAT
├── route53-vpc/          # VPC with Route 53 private DNS
└── ec2-connect-s3/       # EC2 Instance Connect with S3 VPC endpoint
```

## Modules

| Module | Description |
|--------|-------------|
| `vpc` | VPC with Internet Gateway |
| `subnet` | Subnet with route table |
| `security-group` | Security group with dynamic rules |
| `ec2-public` | EC2 instance with key pair generation |
| `ec2-private` | EC2 instance for private subnets |
| `nat-gateway` | NAT Gateway with Elastic IP |
| `route53` | Private hosted zone with DNS records |
| `dhcp-options` | DHCP options set |
| `iam-role` | IAM role with instance profile |
| `vpc-endpoint` | VPC endpoints (Gateway/Interface) |
| `ec2-connect-endpoint` | EC2 Instance Connect endpoint |

## Projects

### EC2
Simple EC2 instance in default VPC with security group.

### VPC Architecture  
Complete VPC setup with public/private subnets, NAT Gateway, and EC2 instances.

### Route53 VPC
VPC with Route 53 private DNS, DHCP options, and cross-instance connectivity testing.

### EC2 Connect S3
VPC with EC2 Instance Connect endpoint and S3 VPC Gateway endpoint for secure connectivity.

## Usage

1. Navigate to project directory
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Requirements

- Terraform >= 1.0
- AWS CLI configured
- AWS Provider ~> 6.0