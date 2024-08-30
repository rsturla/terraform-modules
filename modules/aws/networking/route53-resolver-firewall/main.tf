data "aws_region" "current" {}

locals {
  managed_domain_lists = {
    "eu-west-1" = {
      # `$ aws route53resolver list-firewall-domain-lists --region eu-west-1`
      AWSManagedDomainsAmazonGuardDutyThreatList = "rslvr-fdl-2f416a2435da4ee6"
      AWSManagedDomainsMalwareDomainList         = "rslvr-fdl-7aba603e4cc343fd"
      AWSManagedDomainsBotnetCommandandControl   = "rslvr-fdl-fad18de921a64bfa"
      AWSManagedDomainsAggregateThreatList       = "rslvr-fdl-a88f2f26cc6a4296"
    }
  }
}

resource "aws_route53_resolver_firewall_config" "this" {
  resource_id        = var.vpc_id
  firewall_fail_open = var.firewall_fail_open
}

resource "aws_route53_resolver_firewall_rule_group" "aws_managed" {
  name = "aws-managed"

  tags = var.tags_all
}

resource "aws_route53_resolver_firewall_rule" "aws_managed" {
  for_each = toset(var.managed_domain_lists)

  name                    = each.key
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.aws_managed.id
  firewall_domain_list_id = local.managed_domain_lists[data.aws_region.current.name][each.key]

  action         = var.managed_domain_list_action
  block_response = var.managed_domain_list_action == "BLOCK" ? "NXDOMAIN" : null

  # Reserve 1xx for custom rules that should be evaluated before the managed rules
  # For example, we may need to allow a specific domain that is blocked by the managed rules
  priority = 200 + index(keys(local.managed_domain_lists[data.aws_region.current.name]), each.key)
}

resource "aws_route53_resolver_firewall_rule_group_association" "aws_managed" {
  name                   = "aws-managed"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.aws_managed.id
  vpc_id                 = var.vpc_id
  priority               = 999

  tags = var.tags_all
}
