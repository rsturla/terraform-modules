resource "aws_sesv2_email_identity" "this" {
  email_identity         = var.email_identity
  configuration_set_name = aws_sesv2_configuration_set.this.configuration_set_name

  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }

  tags = var.tags_all
}

resource "aws_sesv2_configuration_set" "this" {
  # Replace invalid characters in the configuration set name
  configuration_set_name = "${replace(replace(upper(var.email_identity), ".", "_"), "@", "-")}-configuration-set"

  delivery_options {
    tls_policy = "REQUIRE"
  }

  reputation_options {
    reputation_metrics_enabled = true
  }

  sending_options {
    sending_enabled = true
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }

  tags = var.tags_all
}

resource "aws_sesv2_email_identity_policy" "this" {
  for_each = var.identity_policies

  email_identity = aws_sesv2_email_identity.this.email_identity
  policy_name    = each.key
  policy         = data.aws_iam_policy_document.identity_policy[each.key].json
}

data "aws_iam_policy_document" "identity_policy" {
  for_each = var.identity_policies

  dynamic "statement" {
    for_each = each.value
    content {
      sid         = statement.key
      effect      = lookup(statement.value, "effect", null)
      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)
      resources   = [aws_sesv2_email_identity.this.arn]

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
