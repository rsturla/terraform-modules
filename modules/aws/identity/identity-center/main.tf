data "aws_ssoadmin_instances" "sso_instance" {}
data "aws_organizations_organization" "organization" {}

resource "aws_identitystore_group" "sso_groups" {
  for_each          = var.sso_groups == null ? {} : var.sso_groups
  identity_store_id = local.sso_instance_id
  display_name      = each.key
  description       = each.value
}

resource "aws_ssoadmin_account_assignment" "account_assignment" {
  for_each = local.principals_and_their_account_assignments

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.permission_set].arn

  principal_type = each.value.principal_type

  principal_id = aws_identitystore_group.sso_groups[each.value.principal_name].id

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
