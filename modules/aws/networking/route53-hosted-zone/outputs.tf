output "ns_records" {
  value       = aws_route53_zone.this.name_servers
  description = "The name servers to use in the domain registrar."
}

output "zone_id" {
  value       = aws_route53_zone.this.zone_id
  description = "The ID of the hosted zone."
}

output "zone_name" {
  value       = aws_route53_zone.this.name
  description = "The name of the hosted zone."
}
