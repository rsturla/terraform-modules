locals {
  default_public_nacl_ingress_rules = {
    DenySSHFromInternetIPv4 = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      action      = "deny"
      cidr_block  = "0.0.0.0/0"
      rule_number = 886
    }
    DenySSHFromInternetIPv6 = {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      action          = "deny"
      ipv6_cidr_block = "::/0"
      rule_number     = 887
    }
    DenyRDPFromInternetIPv4 = {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      action      = "deny"
      cidr_block  = "0.0.0.0/0"
      rule_number = 888
    }
    DenyRDPFromInternetIPv6 = {
      from_port       = 3389
      to_port         = 3389
      protocol        = "tcp"
      action          = "deny"
      ipv6_cidr_block = "::/0"
      rule_number     = 899
    }
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

  default_public_nacl_egress_rules = {
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

resource "aws_network_acl" "public_subnets" {
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  tags = merge(
    { Name = "${data.aws_vpc.this.tags.Name}-public-subnets" },
    var.tags_all,
  )
}

resource "aws_network_acl_rule" "public_subnets_ingress" {
  // Merge the default rules with the provided rules
  for_each = merge(local.default_public_nacl_ingress_rules, var.public_subnet_nacl_ingress_rules)

  network_acl_id = aws_network_acl.public_subnets.id
  // If the rule is a default rule, use the rule_number from the default rule.  Otherwise get the index of the rule in the provided rules
  rule_number     = contains(keys(local.default_public_nacl_ingress_rules), each.key) ? local.default_public_nacl_ingress_rules[each.key]["rule_number"] : index(keys(var.public_subnet_nacl_ingress_rules), each.key)
  protocol        = each.value["protocol"]
  rule_action     = each.value["action"]
  cidr_block      = each.value["cidr_block"]
  ipv6_cidr_block = each.value["ipv6_cidr_block"]
  from_port       = each.value["from_port"]
  to_port         = each.value["to_port"]
}

resource "aws_network_acl_rule" "public_subnets_egress" {
  for_each = merge(local.default_public_nacl_egress_rules, var.public_subnet_nacl_egress_rules)

  network_acl_id  = aws_network_acl.public_subnets.id
  rule_number     = contains(keys(local.default_public_nacl_egress_rules), each.key) ? local.default_public_nacl_egress_rules[each.key]["rule_number"] : index(keys(var.public_subnet_nacl_egress_rules), each.key)
  protocol        = each.value["protocol"]
  rule_action     = each.value["action"]
  cidr_block      = each.value["cidr_block"]
  ipv6_cidr_block = each.value["ipv6_cidr_block"]
  from_port       = each.value["from_port"]
  to_port         = each.value["to_port"]
}

resource "aws_network_acl_association" "public_subnets" {
  for_each = toset(var.public_subnet_ids)

  subnet_id      = each.key
  network_acl_id = aws_network_acl.public_subnets.id
}
