locals {
  # Retrieve the first SSO instance ARN and identity store ID
  ssoadmin_instance_arn = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  sso_instance_id       = tolist(data.aws_ssoadmin_instances.sso_instance.identity_store_ids)[0]

  # Filter permission sets based on the presence of different policy types
  aws_managed_permission_sets = {
    for pset_name, pset_index in var.permission_sets :
    pset_name => pset_index
    if length(coalesce(pset_index.aws_managed_policies, [])) > 0
  }

  inline_policy_permission_sets = {
    for pset_name, pset_index in var.permission_sets :
    pset_name => pset_index
    if can(pset_index.inline_policy)
  }

  permissions_boundary_aws_managed_permission_sets = {
    for pset_name, pset_index in var.permission_sets :
    pset_name => pset_index
    if can(pset_index.permissions_boundary.managed_policy_arn)
  }

  permissions_boundary_customer_managed_permission_sets = {
    for pset_name, pset_index in var.permission_sets :
    pset_name => pset_index
    if can(pset_index.permissions_boundary.customer_managed_policy_reference)
  }

  customer_managed_permission_sets = {
    for pset_name, pset_index in var.permission_sets :
    pset_name => pset_index
    if length(coalesce(pset_index.customer_managed_policies, [])) > 0
  }

  # Map AWS managed policies to permission sets
  pset_aws_managed_policy_maps = flatten([
    for pset_name, pset_index in local.aws_managed_permission_sets : [
      for policy in pset_index.aws_managed_policies : {
        pset_name  = pset_name
        policy_arn = policy
      } if can(policy)
    ]
  ])

  # Map customer managed policies to permission sets
  pset_customer_managed_policy_maps = flatten([
    for pset_name, pset_index in local.customer_managed_permission_sets : [
      for policy in pset_index.customer_managed_policies : {
        pset_name   = pset_name
        policy_name = policy.name
        path        = policy.path
      } if can(policy)
    ]
  ])

  # Map inline policies to permission sets
  pset_inline_policy_maps = flatten([
    for pset_name, pset_index in local.inline_policy_permission_sets : [
      {
        pset_name     = pset_name
        inline_policy = pset_index.inline_policy
      }
    ]
  ])

  # Map AWS managed permissions boundaries to permission sets
  pset_permissions_boundary_aws_managed_maps = flatten([
    for pset_name, pset_index in local.permissions_boundary_aws_managed_permission_sets : [
      {
        pset_name = pset_name
        boundary = {
          managed_policy_arn = pset_index.permissions_boundary.managed_policy_arn
        }
      }
    ]
  ])

  # Map customer managed permissions boundaries to permission sets
  pset_permissions_boundary_customer_managed_maps = flatten([
    for pset_name, pset_index in local.permissions_boundary_customer_managed_permission_sets : [
      {
        pset_name = pset_name
        boundary = {
          customer_managed_policy_reference = pset_index.permissions_boundary.customer_managed_policy_reference
        }
      }
    ]
  ])

  # Filter active accounts from the organization
  active_accounts = [
    for account in data.aws_organizations_organization.organization.accounts :
    account if account.status == "ACTIVE"
  ]

  # Map account names to IDs for active accounts
  accounts_ids_maps = {
    for account in local.active_accounts :
    account.name => account.id
  }

  # Flatten account assignments data
  flatten_account_assignment_data = flatten([
    for this_assignment in keys(var.account_assignments) : [
      for account in var.account_assignments[this_assignment].account_ids : [
        for pset in var.account_assignments[this_assignment].permission_sets : {
          permission_set = pset
          principal_name = var.account_assignments[this_assignment].principal_name
          principal_type = var.account_assignments[this_assignment].principal_type
          account_id     = length(regexall("[0-9]{12}", account)) > 0 ? account : lookup(local.accounts_ids_maps, account, null)
        }
      ]
    ]
  ])

  # Map principals and their account assignments
  principals_and_their_account_assignments = {
    for s in local.flatten_account_assignment_data :
    format("Type:%s__Principal:%s__Permission:%s__Account:%s", s.principal_type, s.principal_name, s.permission_set, s.account_id) => s
  }
}
