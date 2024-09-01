resource "aws_backup_plan" "plan" {
  for_each = var.plans
  name     = each.key

  tags = var.tags_all

  dynamic "rule" {
    for_each = each.value.rules

    content {
      rule_name         = rule.key
      target_vault_name = rule.value.target_vault_name
      schedule          = rule.value.schedule

      dynamic "lifecycle" {
        for_each = rule.value.lifecycle[*]
        content {
          cold_storage_after = lifecycle.value.cold_storage_after
          delete_after       = lifecycle.value.delete_after
        }
      }

      dynamic "copy_action" {
        for_each = rule.value.copy_action[*]
        content {
          destination_vault_arn = copy_action.value.destination_vault_arn

          dynamic "lifecycle" {
            for_each = copy_action.value.lifecycle[*]
            content {
              cold_storage_after = lifecycle.value.cold_storage_after
              delete_after       = lifecycle.value.delete_after
            }
          }
        }
      }
    }
  }
}

resource "aws_backup_selection" "selection" {
  for_each = var.plans

  iam_role_arn = aws_iam_role.backup_service_role.arn
  name         = "${each.key}-selection"
  plan_id      = aws_backup_plan.plan[each.key].id

  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      dynamic "string_equals" {
        for_each = condition.value.string_equals

        content {
          key   = string_equals.key
          value = string_equals.value
        }
      }
    }
  }

  resources = each.value.resources
}
