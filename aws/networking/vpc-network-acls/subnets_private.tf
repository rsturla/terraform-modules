locals {
  default_private_nacl_ingress_rules = {
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

  default_private_nacl_egress_rules = {
    AllowAllIPv4 = {
      from_port   = 0
      to_port     = 0
      action      = "allow"
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      rule_number = 998
    }
    AllowAllIPv6 = {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
      rule_number     = 999
    }
  }
}

resource "aws_network_acl" "private_subnets" {
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  tags = merge(
    { Name = "${data.aws_vpc.this.tags.Name}-private-subnets" },
    var.tags_all,
  )
}

resource "aws_network_acl_rule" "private_subnets_ingress" {
  // Merge the default rules with the provided rules
  for_each = merge(local.default_private_nacl_ingress_rules, var.private_subnet_nacl_ingress_rules)

  network_acl_id = aws_network_acl.private_subnets.id
  egress         = false
  // If the rule is a default rule, use the rule_number from the default rule.  Otherwise get the index of the rule in the provided rules
  rule_number     = contains(keys(local.default_private_nacl_ingress_rules), each.key) ? local.default_private_nacl_ingress_rules[each.key]["rule_number"] : index(keys(var.private_subnet_nacl_ingress_rules), each.key)
  protocol        = each.value["protocol"]
  rule_action     = each.value["action"]
  cidr_block      = each.value["cidr_block"]
  ipv6_cidr_block = each.value["ipv6_cidr_block"]
  from_port       = each.value["from_port"]
  to_port         = each.value["to_port"]
}

resource "aws_network_acl_rule" "private_subnets_egress" {
  for_each = merge(local.default_private_nacl_egress_rules, var.private_subnet_nacl_egress_rules)

  network_acl_id  = aws_network_acl.private_subnets.id
  egress          = true
  rule_number     = contains(keys(local.default_private_nacl_egress_rules), each.key) ? local.default_private_nacl_egress_rules[each.key]["rule_number"] : index(keys(var.private_subnet_nacl_egress_rules), each.key)
  protocol        = each.value["protocol"]
  rule_action     = each.value["action"]
  cidr_block      = each.value["cidr_block"]
  ipv6_cidr_block = each.value["ipv6_cidr_block"]
  from_port       = each.value["from_port"]
  to_port         = each.value["to_port"]
}

resource "aws_network_acl_association" "private_subnets" {
  for_each = toset(var.private_subnet_ids)

  subnet_id      = each.key
  network_acl_id = aws_network_acl.private_subnets.id
}
