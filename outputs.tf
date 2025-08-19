output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_instance_ip" {
  description = "Public IP of the public instance"
  value       = module.public_ec2.public_ip
}

output "private_instance_ip" {
  description = "Private IP of the private instance"
  value       = module.private_ec2.private_ip
}

output "ssh_command" {
  description = "SSH command to connect to public instance"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${module.public_ec2.public_ip}"
}