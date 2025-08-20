variable "domain_name" {
  description = "Domain name for the private hosted zone"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with the hosted zone"
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records (name -> IP)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}