output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.subnet.id
}

output "route_table_id" {
  description = "ID of the route table"
  value       = aws_route_table.subnet_rt.id
}