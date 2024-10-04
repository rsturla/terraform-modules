data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringLike"
      values   = ["repo:${var.repository}:${var.git_pattern}"]
      variable = "token.actions.githubusercontent.com:sub"
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    principals {
      type        = "Federated"
      identifiers = [var.create_openid_connect_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.key
}

resource "aws_iam_role_policy_attachment" "custom_policy" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom_policy[0].arn
}

resource "aws_iam_policy" "custom_policy" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  name        = "${var.name}-policy"
  description = "The IAM policy for the GitHub Actions role"
  policy      = data.aws_iam_policy_document.custom_policy[0].json
}

data "aws_iam_policy_document" "custom_policy" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid         = statement.key
      effect      = lookup(statement.value, "effect", null)
      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)
      resources   = lookup(statement.value, "resources", null)

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
