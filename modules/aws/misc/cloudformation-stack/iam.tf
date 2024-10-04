resource "aws_iam_role" "cloudformation_stack_assume_role" {
  name               = "${var.name}-assume-role"
  assume_role_policy = data.aws_iam_policy_document.cloudformation_stack_assume_role.json
  tags = merge(var.tags_all, {
    Name = "${var.name}-assume-role",
  })
}

data "aws_iam_policy_document" "cloudformation_stack_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudformation_stack_assume_policy" {
  count = length(var.assume_policy_statements) > 0 ? 1 : 0
  dynamic "statement" {
    for_each = var.assume_policy_statements
    content {
      sid         = statement.key
      effect      = lookup(statement.value, "effect", null)
      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)
      resources   = lookup(statement.value, "resources", ["*"])

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", {})
        content {
          type        = principals.key
          identifiers = principals.value
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", {})
        content {
          type        = not_principals.key
          identifiers = not_principals.value
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", {})
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "additional_permissions_policy" {
  count  = length(var.assume_policy_statements) > 0 ? 1 : 0
  name   = "${var.name}-additional-permissions-policy"
  policy = data.aws_iam_policy_document.cloudformation_stack_assume_policy[0].json
}

resource "aws_iam_policy_attachment" "additional_permissions_attachment" {
  count = length(var.assume_policy_statements) > 0 ? 1 : 0
  name  = "${var.name}-assume-policy-attachment"
  roles = [
    aws_iam_role.cloudformation_stack_assume_role.name,
  ]
  policy_arn = aws_iam_policy.additional_permissions_policy[0].arn
}
