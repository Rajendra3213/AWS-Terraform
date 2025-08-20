output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "ec2_private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.ec2.private_ip
}

output "connect_endpoint_id" {
  description = "EC2 Instance Connect endpoint ID"
  value       = module.connect_endpoint.endpoint_id
}

output "s3_endpoint_id" {
  description = "S3 VPC endpoint ID"
  value       = module.s3_endpoint.endpoint_id
}

output "test_commands" {
  description = "Commands to test S3 connectivity"
  value = [
    "aws s3 ls",
    "echo 'test file' > test.txt",
    "aws s3 cp test.txt s3://your-bucket-name/",
    "aws s3 cp s3://your-bucket-name/test.txt downloaded.txt"
  ]
}