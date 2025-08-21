resource "aws_vpc_endpoint" "endpoint" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.endpoint_type
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  route_table_ids     = var.route_table_ids
  
  tags = var.tags
}