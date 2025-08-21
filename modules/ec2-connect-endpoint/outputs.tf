output "endpoint_id" {
  description = "EC2 Instance Connect endpoint ID"
  value       = aws_ec2_instance_connect_endpoint.endpoint.id
}