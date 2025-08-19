output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.private.id
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.private.private_ip
}