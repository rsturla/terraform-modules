output "destination_arn" {
  value = aws_route53_resolver_query_log_config.this.destination_arn
}

output "resolver_config_name" {
  value = aws_route53_resolver_query_log_config.this.name
}
