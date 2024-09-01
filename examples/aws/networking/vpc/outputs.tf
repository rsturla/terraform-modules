output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_ipv6_cidr_block" {
  value = module.vpc.vpc_ipv6_cidr_block
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnet_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  value = module.vpc.public_subnet_ipv6_cidr_blocks
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "private_app_subnet_cidr_blocks" {
  value = module.vpc.private_app_subnet_cidr_blocks
}

output "private_app_subnet_ipv6_cidr_blocks" {
  value = module.vpc.private_app_subnet_ipv6_cidr_blocks
}

output "private_persistence_subnet_ids" {
  value = module.vpc.private_persistence_subnet_ids
}

output "private_persistence_subnet_cidr_blocks" {
  value = module.vpc.private_persistence_subnet_cidr_blocks
}

output "private_persistence_subnet_ipv6_cidr_blocks" {
  value = module.vpc.private_persistence_subnet_ipv6_cidr_blocks
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_gateway_public_ips
}

output "nat_instance_public_ips" {
  value = module.vpc.nat_instance_public_ips
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "egress_only_internet_gateway_id" {
  value = module.vpc.egress_only_internet_gateway_id
}
