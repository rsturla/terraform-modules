# Prepare locals so we have a shortcut to the exported properties of the organization
locals {
  root_id = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].roots.0.id
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].roots.0.id
      : null
    )
  )
  organization_arn = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].arn
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].arn
      : null
    )
  )
  organization_id = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].id
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].id
      : null
    )
  )
  master_account_arn = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].master_account_arn
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].master_account_arn
      : null
    )
  )
  master_account_id = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].master_account_id
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].master_account_id
      : null
    )
  )
  master_account_email = (
    length(aws_organizations_organization.root) > 0
    ? aws_organizations_organization.root[0].master_account_email
    : (
      length(data.aws_organizations_organization.root) > 0
      ? data.aws_organizations_organization.root[0].master_account_email
      : null
    )
  )
}
