variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "service_name" {
  description = "Service name for VPC endpoint"
  type        = string
}

variable "endpoint_type" {
  description = "VPC endpoint type"
  type        = string
  default     = "Gateway"
}

variable "subnet_ids" {
  description = "Subnet IDs for Interface endpoints"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs for Interface endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "Route table IDs for Gateway endpoints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}