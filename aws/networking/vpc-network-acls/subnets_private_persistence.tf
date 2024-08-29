locals {
  default_private_persistence_nacl_ingress_rules = {
    AllowVPCIPv4 = {
      from_port   = 0
      to_port     = 0
      action      = "allow"
      protocol    = "-1"
      cidr_block  = data.aws_vpc.this.cidr_block
      rule_number = 998
    }
    AllowAllIPv6 = {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = data.aws_vpc.this.ipv6_cidr_block
      rule_number     = 999
    }
  }

  default_private_persistence_nacl_egress_rules = {
    AllowVPCIPv4 = {
      from_port   = 0
      to_port     = 0
      action      = "allow"
      protocol    = "-1"
      cidr_block  = data.aws_vpc.this.cidr_block
      rule_number = 996
    }
    AllowVPCIPv6 = {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = data.aws_vpc.this.ipv6_cidr_block
      rule_number     = 997
    }
    AllowInternetIPv4 = var.allow_private_persistence_internet_access ? {
      from_port   = 0
      to_port     = 0
      action      = "allow"
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      rule_number = 998
    } : null
    AllowInternetIPv6 = var.allow_private_persistence_internet_access ? {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
      rule_number     = 999
    } : null
  }

  flattened_private_persistence_nacl_ingress_rules = {
    for k, v in merge(
      local.default_private_persistence_nacl_ingress_rules,
      var.private_persistence_subnet_nacl_ingress_rules
    ) :
    k => v if v != null
  }

  flattened_private_persistence_nacl_egress_rules = {
    for k, v in merge(
      local.default_private_persistence_nacl_egress_rules,
      var.private_persistence_subnet_nacl_egress_rules
    ) :
    k => v if v != null
  }
}

resource "aws_network_acl" "private_persistence_subnets" {
  vpc_id     = var.vpc_id
  subnet_ids = var.private_persistence_subnet_ids
  tags = merge(
    { Name = "${data.aws_vpc.this.tags.Name}-private_persistence-subnets" },
    var.tags_all,
  )
}

resource "aws_network_acl_rule" "private_persistence_subnets_ingress" {
  for_each = local.flattened_private_persistence_nacl_ingress_rules

  network_acl_id  = aws_network_acl.private_persistence_subnets.id
  rule_number     = lookup(each.value, "rule_number")
  protocol        = lookup(each.value, "protocol")
  rule_action     = lookup(each.value, "action")
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port")
  to_port         = lookup(each.value, "to_port")
}

resource "aws_network_acl_rule" "private_persistence_subnets_egress" {
  for_each = local.flattened_private_persistence_nacl_egress_rules

  network_acl_id  = aws_network_acl.private_persistence_subnets.id
  rule_number     = lookup(each.value, "rule_number")
  protocol        = lookup(each.value, "protocol")
  rule_action     = lookup(each.value, "action")
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port")
  to_port         = lookup(each.value, "to_port")
  egress          = true
}

resource "aws_network_acl_association" "private_persistence_subnets" {
  count = length(var.private_persistence_subnet_ids)

  subnet_id      = var.private_persistence_subnet_ids[count.index]
  network_acl_id = aws_network_acl.private_persistence_subnets.id
}