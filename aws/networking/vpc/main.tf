locals {
  private_app_subnet_spacing        = var.private_app_subnet_spacing != null ? var.private_app_subnet_spacing : var.subnet_spacing
  private_peristence_subnet_spacing = var.private_persistence_subnet_spacing != null ? var.private_persistence_subnet_spacing : 2 * var.subnet_spacing
}

data "aws_availability_zones" "all" {}
data "aws_region" "current" {}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  # Currently, only support AWS-provided IPv6 CIDR blocks
  assign_generated_ipv6_cidr_block = true


  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}

resource "aws_route" "default_ipv4_internet" {
  route_table_id         = aws_default_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  depends_on = [
    aws_internet_gateway.this,
    aws_default_route_table.default,
  ]
}

resource "aws_route" "default_ipv6_internet" {
  route_table_id              = aws_default_route_table.default.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id

  depends_on = [
    aws_internet_gateway.this,
    aws_default_route_table.default,
  ]
}

resource "aws_default_security_group" "default" {
  count = var.enable_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}
