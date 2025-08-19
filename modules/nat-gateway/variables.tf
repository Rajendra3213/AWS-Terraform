variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "nat_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}