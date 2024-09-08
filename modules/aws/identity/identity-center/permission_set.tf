resource "aws_ssoadmin_permission_set" "pset" {
  for_each = var.permission_sets
  name     = each.key

  instance_arn     = local.ssoadmin_instance_arn
  description      = lookup(each.value, "description", null)
  relay_state      = lookup(each.value, "relay_state", null)
  session_duration = lookup(each.value, "session_duration", null)
  tags             = merge(lookup(each.value, "tags", {}), var.tags_all)
}


resource "aws_ssoadmin_managed_policy_attachment" "pset_aws_managed_policy" {
  for_each = { for pset in local.pset_aws_managed_policy_maps : "${pset.pset_name}.${pset.policy_arn}" => pset }

  instance_arn       = local.ssoadmin_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.pset_name].arn

  depends_on = [aws_ssoadmin_account_assignment.account_assignment]
}


resource "aws_ssoadmin_customer_managed_policy_attachment" "pset_customer_managed_policy" {
  for_each = { for pset in local.pset_customer_managed_policy_maps : "${pset.pset_name}.${pset.policy_name}" => pset }

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.pset_name].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = each.value.path
  }

}

resource "aws_ssoadmin_permission_set_inline_policy" "pset_inline_policy" {
  for_each = { for pset in local.pset_inline_policy_maps : pset.pset_name => pset if can(pset.inline_policy) }

  inline_policy      = each.value.inline_policy
  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.key].arn
}

resource "aws_ssoadmin_permissions_boundary_attachment" "pset_permissions_boundary_aws_managed" {
  for_each = { for pset in local.pset_permissions_boundary_aws_managed_maps : pset.pset_name => pset if can(pset.boundary.managed_policy_arn) }

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.key].arn
  permissions_boundary {
    managed_policy_arn = each.value.boundary.managed_policy_arn
  }
}

resource "aws_ssoadmin_permissions_boundary_attachment" "pset_permissions_boundary_customer_managed" {
  for_each = { for pset in local.pset_permissions_boundary_customer_managed_maps : pset.pset_name => pset if can(pset.boundary.customer_managed_policy_reference) }

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.key].arn
  permissions_boundary {
    customer_managed_policy_reference {
      name = each.value.boundary.customer_managed_policy_reference.name
      path = can(each.value.boundary.customer_managed_policy_reference.path) ? each.value.boundary.customer_managed_policy_reference.path : "/"
    }

  }
}
