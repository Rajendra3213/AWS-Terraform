output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.public.id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.public.public_ip
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.public.private_ip
}