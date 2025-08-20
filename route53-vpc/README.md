# Route 53 VPC Project

This project creates a VPC with public and private subnets, EC2 instances, Route 53 private hosted zone, and DHCP options.

## Architecture

- **VPC**: 10.0.0.0/16 with DNS hostnames and support enabled
- **Public Subnet**: 10.0.1.0/24 with Internet Gateway route
- **Private Subnet**: 10.0.2.0/24 
- **Security Group**: Allows SSH (port 22) and ICMP IPv4
- **EC2 Instances**:
  - `app` instance in public subnet
  - `db` instance in private subnet
- **Route 53**: Private hosted zone for `corp.internal`
- **DHCP Options**: Domain set to `corp.internal`

## DNS Records

- `app.corp.internal` → App instance private IP
- `db.corp.internal` → DB instance private IP

## Usage

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. SSH into the app instance:
   ```bash
   ssh -i route53-vpc-key.pem ec2-user@<app_public_ip>
   ```

6. From the app instance, ping the db instance using DNS:
   ```bash
   ping db.corp.internal
   ```

## Cleanup

```bash
terraform destroy
```

## Modules Used

This project uses the following consolidated modules:
- `vpc` - Creates VPC and Internet Gateway
- `subnet` - Creates subnets with route tables
- `security-group` - Creates security groups with rules
- `ec2-public` - Creates EC2 instance in public subnet with key pair
- `ec2-private` - Creates EC2 instance in private subnet
- `route53` - Creates private hosted zone and DNS records
- `dhcp-options` - Creates and associates DHCP options set