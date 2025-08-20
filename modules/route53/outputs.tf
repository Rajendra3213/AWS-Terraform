output "zone_id" {
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.private.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.private.name_servers
}