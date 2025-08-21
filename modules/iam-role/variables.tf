variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "service" {
  description = "AWS service that can assume this role"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "policy_arns" {
  description = "List of policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}