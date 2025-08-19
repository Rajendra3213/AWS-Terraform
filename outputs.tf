# VPC Resources
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

# Subnet Resources
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.private_subnet.subnet_id
}

# NAT Gateway
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}

# Security Groups
output "public_security_group_id" {
  description = "ID of the public security group"
  value       = module.public_sg.security_group_id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = module.private_sg.security_group_id
}

# EC2 Instances
output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = module.public_ec2.instance_id
}

output "public_instance_public_ip" {
  description = "Public IP of the public instance"
  value       = module.public_ec2.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP of the public instance"
  value       = module.public_ec2.private_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = module.private_ec2.instance_id
}

output "private_instance_private_ip" {
  description = "Private IP of the private instance"
  value       = module.private_ec2.private_ip
}

# Connection Commands
output "ssh_to_public_instance" {
  description = "SSH command to connect to public instance"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${module.public_ec2.public_ip}"
}

output "ssh_to_private_instance" {
  description = "SSH command to connect to private instance via public instance"
  value       = "ssh -i ${var.key_name}.pem -o ProxyCommand='ssh -i ${var.key_name}.pem -W %h:%p ec2-user@${module.public_ec2.public_ip}' ec2-user@${module.private_ec2.private_ip}"
}