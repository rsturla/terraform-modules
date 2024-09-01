output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.this.ipv6_cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value = {
    for subnet in aws_subnet.public : subnet.availability_zone => subnet.id
  }
}

output "public_subnet_cidr_blocks" {
  description = "The CIDR blocks of the public subnets"
  value = {
    for subnet in aws_subnet.public : subnet.availability_zone => subnet.cidr_block
  }
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "The IPv6 CIDR blocks of the public subnets"
  value = {
    for subnet in aws_subnet.public : subnet.availability_zone => subnet.ipv6_cidr_block
  }
}

output "private_app_subnet_ids" {
  description = "The IDs of the private app subnets"
  value = {
    for subnet in aws_subnet.private_app : subnet.availability_zone => subnet.id
  }
}

output "private_app_subnet_cidr_blocks" {
  description = "The CIDR blocks of the private app subnets"
  value = {
    for subnet in aws_subnet.private_app : subnet.availability_zone => subnet.cidr_block
  }
}

output "private_app_subnet_ipv6_cidr_blocks" {
  description = "The IPv6 CIDR blocks of the private app subnets"
  value = {
    for subnet in aws_subnet.private_app : subnet.availability_zone => subnet.ipv6_cidr_block
  }
}

output "private_persistence_subnet_ids" {
  description = "The IDs of the private persistence subnets"
  value = {
    for subnet in aws_subnet.private_persistence : subnet.availability_zone => subnet.id
  }
}

output "private_persistence_subnet_cidr_blocks" {
  description = "The CIDR blocks of the private persistence subnets"
  value = {
    for subnet in aws_subnet.private_persistence : subnet.availability_zone => subnet.cidr_block
  }
}

output "private_persistence_subnet_ipv6_cidr_blocks" {
  description = "The IPv6 CIDR blocks of the private persistence subnets"
  value = {
    for subnet in aws_subnet.private_persistence : subnet.availability_zone => subnet.ipv6_cidr_block
  }
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT gateways"
  value       = aws_nat_gateway.nat[*].id
}

output "nat_gateway_public_ips" {
  description = "The public IPs of the NAT gateways"
  value       = aws_eip.nat[*].public_ip
}

output "nat_instance_public_ips" {
  description = "The public IPs of the NAT instances"
  value = {
    for instance in module.nat_instance : instance.availability_zone => instance.eip
  }
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress-only internet gateway"
  value       = aws_egress_only_internet_gateway.this.id
}
