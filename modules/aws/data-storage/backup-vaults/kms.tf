resource "aws_kms_key" "backup" {
  count = var.create_kms_key ? 1 : 0

  description         = "KMS key for backup vaults"
  enable_key_rotation = true
  tags                = var.tags_all
}

resource "aws_kms_alias" "backup" {
  count = var.create_kms_key ? 1 : 0

  name          = var.kms_key_alias
  target_key_id = aws_kms_key.backup[0].key_id
}

resource "aws_kms_key_policy" "backup" {
  count = var.create_kms_key ? 1 : 0

  key_id = aws_kms_key.backup[0].key_id
  policy = data.aws_iam_policy_document.backup[0].json
}

data "aws_iam_policy_document" "backup" {
  count = var.create_kms_key ? 1 : 0

  dynamic "statement" {
    for_each = length(var.backup_source_accounts) > 0 ? [1] : []
    content {
      sid    = "AllowUsingKMSKey"
      effect = "Allow"
      actions = [
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey",
        "kms:GenerateDataKeyWithoutPlaintext",
      ]
      resources = [
        "*"
      ]
      principals {
        type        = "AWS"
        identifiers = var.backup_source_accounts
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.backup_source_accounts) > 0 ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant",
      ]
      principals {
        type        = "AWS"
        identifiers = var.backup_source_accounts
      }
      resources = ["*"]
      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = ["true"]
      }
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}
