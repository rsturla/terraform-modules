data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  is_delegated_administrator_account = var.delegated_administrator_account_id == data.aws_caller_identity.current.account_id

  # Get all the account ids from var.enabled_account_ids where the account id is not the current account id
  enabled_account_ids = [for account_id in var.enabled_account_ids : account_id if account_id != data.aws_caller_identity.current.account_id]
}

resource "aws_inspector2_organization_configuration" "this" {
  count = local.is_delegated_administrator_account && var.auto_enable_member_accounts ? 1 : 0

  auto_enable {
    ec2    = contains(var.resource_types, "EC2")
    ecr    = contains(var.resource_types, "ECR")
    lambda = contains(var.resource_types, "LAMBDA")
  }
}
