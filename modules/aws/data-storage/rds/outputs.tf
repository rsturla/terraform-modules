output "primary_address" {
  value       = try(aws_route53_record.primary[0].fqdn, aws_db_instance.primary.address)
  description = "The primary address of the database"
}

output "database_name" {
  value       = aws_db_instance.primary.db_name
  description = "The name of the database"
}

output "database_port" {
  value       = aws_db_instance.primary.port
  description = "The port of the database"
}

output "consumer_security_group_id" {
  value       = aws_security_group.consumer.id
  description = "The ID of the security group used to allow access to the database"
}
