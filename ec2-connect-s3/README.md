# EC2 Instance Connect with S3 VPC Endpoint

This project creates a VPC with EC2 Instance Connect endpoint and S3 VPC Gateway endpoint for secure connectivity.

## Architecture

- **VPC**: 10.0.0.0/16 with two private subnets
- **Subnet1**: 10.0.1.0/24 for EC2 Instance Connect endpoint
- **Subnet2**: 10.0.2.0/24 for EC2 instance
- **Security Groups**:
  - EC2 SG: SSH inbound from VPC, HTTPS outbound
  - Connect SG: SSH outbound to EC2 instance
- **IAM Role**: S3 full access for EC2 instance
- **VPC Endpoints**: S3 Gateway endpoint for private S3 access

## Usage

1. Copy variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Deploy infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Connect to EC2 instance:
   - Go to AWS Console → EC2 → Instances
   - Select the instance → Connect → EC2 Instance Connect

4. Test S3 connectivity:
   ```bash
   aws s3 ls
   echo 'test file' > test.txt
   aws s3 cp test.txt s3://your-bucket-name/
   ```

## Features

✅ VPC with private subnets  
✅ EC2 Instance Connect endpoint  
✅ S3 VPC Gateway endpoint  
✅ IAM role with S3 permissions  
✅ Security groups for SSH and HTTPS  
✅ Route table configuration for S3 access