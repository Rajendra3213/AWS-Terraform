variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  default     = ""
  
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  default     = ""
}



variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for subnet1 (EC2 Connect endpoint)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for subnet2 (EC2 instance)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "ec2-connect-s3"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "lab"
    Project     = "ec2-connect-s3"
  }
}