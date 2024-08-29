data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  is_delegated_administrator = var.delegated_administrator_account_id == data.aws_caller_identity.current.account_id
}

resource "aws_securityhub_account" "this" {
  count = var.create_resources ? 1 : 0

  enable_default_standards  = var.enable_default_standards
  control_finding_generator = var.control_finding_generator
  auto_enable_controls      = var.auto_enable_controls
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each = var.create_resources ? { for standard in var.standards : standard => standard } : {}

  standards_arn = startswith(each.value, "ruleset/") ? "arn:${data.aws_partition.current.partition}:securityhub:::${each.value}" : "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::${each.value}"

  depends_on = [
    aws_securityhub_account.this,
  ]
}

resource "aws_securityhub_member" "external" {
  for_each = var.create_resources && local.is_delegated_administrator ? var.external_member_accounts : {}

  account_id = each.value.account_id
  email      = each.value.email
  invite     = true

  depends_on = [
    aws_securityhub_account.this,
  ]
}

resource "aws_securityhub_invite_accepter" "external" {
  count = var.create_resources && !local.is_delegated_administrator && var.delegated_administrator_account_id != null ? 1 : 0

  master_id = var.delegated_administrator_account_id

  depends_on = [aws_securityhub_account.this]
}

resource "aws_securityhub_finding_aggregator" "this" {
  count = var.create_resources && local.is_delegated_administrator && var.is_aggregate_region ? 1 : 0

  linking_mode = "ALL_REGIONS"

  depends_on = [aws_securityhub_account.this]
}
