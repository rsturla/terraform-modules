data "aws_caller_identity" "current" {}

locals {
  is_delegated_administrator_account = var.delegated_administrator_account_id == data.aws_caller_identity.current.account_id
  enabled_account_ids                = [for account_id in var.enabled_account_ids : account_id if account_id != data.aws_caller_identity.current.account_id]
}

resource "aws_inspector2_delegated_admin_account" "enable" {
  count = var.create_resources && var.is_organization_management_account && var.delegated_administrator_account_id != null ? 1 : 0

  account_id = var.delegated_administrator_account_id
}

resource "aws_inspector2_enabler" "enable" {
  count          = var.create_resources ? 1 : 0
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = var.resource_types
}

resource "aws_inspector2_member_association" "enable" {
  for_each = var.create_resources && local.is_delegated_administrator_account ? toset(local.enabled_account_ids) : toset([])

  account_id = each.key

  depends_on = [
    aws_inspector2_organization_configuration.this,
    aws_inspector2_enabler.enable,
  ]
}
