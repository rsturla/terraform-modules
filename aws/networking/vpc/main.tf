data "aws_availability_zones" "all" {}
data "aws_region" "current" {}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  # Currently, we only support AWS-provided IPv6 CIDR blocks
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
  count = var.apply_default_nacl_rules ? 1 : 0

  default_network_acl_id = aws_vpc.this.default_network_acl_id
  subnet_ids = (
    sort(concat(
      aws_subnet.public[*].id,
      aws_subnet.private_app[*].id,
      aws_subnet.private_persistence[*].id
    ))
  )

  dynamic "ingress" {
    for_each = var.default_nacl_ingress_rules
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      action          = ingress.value["action"]
      rule_no         = ingress.value["rule_no"]
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
    }
  }

  dynamic "egress" {
    for_each = var.default_nacl_egress_rules
    content {
      from_port       = egress.value["from_port"]
      to_port         = egress.value["to_port"]
      protocol        = egress.value["protocol"]
      action          = egress.value["action"]
      rule_no         = egress.value["rule_no"]
      cidr_block      = lookup(egress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
    }
  }

  tags = merge(
    { Name = var.name },
    var.tags_all,
  )
}
