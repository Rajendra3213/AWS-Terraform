variable "subnet_id" {
  description = "Subnet ID for EC2 Instance Connect endpoint"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}