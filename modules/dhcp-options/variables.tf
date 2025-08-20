variable "domain_name" {
  description = "Domain name for DHCP options"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate DHCP options with"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}