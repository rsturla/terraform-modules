output "eip" {
  value = aws_eip.public_ip.public_ip
}

output "security_group_arn" {
  value = aws_security_group.this.arn
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "network_interface_id" {
  value = aws_network_interface.this.id
}

output "availability_zone" {
  value = var.availability_zone
}
