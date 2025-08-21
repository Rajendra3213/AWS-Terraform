output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "app_public_ip" {
  description = "Public IP of app instance"
  value       = aws_instance.app.public_ip
}

output "app_private_ip" {
  description = "Private IP of app instance"
  value       = aws_instance.app.private_ip
}

output "db_private_ip" {
  description = "Private IP of db instance"
  value       = aws_instance.db.private_ip
}

output "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = module.route53.zone_id
}

output "ssh_command" {
  description = "SSH command to connect to app instance"
  value       = "ssh -i ${var.vpc_name}-key-new.pem ubuntu@${aws_instance.app.public_ip}"
}

output "ping_command" {
  description = "Command to ping db instance from app instance"
  value       = "ping db.${var.domain_name}"
}