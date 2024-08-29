resource "aws_s3_bucket" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  bucket = var.export_bucket_name
}

resource "aws_s3_bucket_public_access_block" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  bucket = aws_s3_bucket.export[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  bucket = aws_s3_bucket.export[0].id
  policy = data.aws_iam_policy_document.export_s3[0].json
}

resource "aws_s3_bucket_versioning" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  bucket = aws_s3_bucket.export[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "export_s3" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  statement {
    sid    = "allow-inspector"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "${aws_s3_bucket.export[0].arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["inspector2.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = concat(local.enabled_account_ids, [data.aws_caller_identity.current.account_id])
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        for account_id in concat(local.enabled_account_ids, [data.aws_caller_identity.current.account_id])
        : "arn:aws:inspector2:${data.aws_region.current.name}:${account_id}:report/*"
      ]
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_version_management" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  bucket = aws_s3_bucket.export[0].id

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_kms_key" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  description             = "KMS key for encrypting AWS Inspector findings exported to S3"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.export_kms[0].json
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "export_kms" {
  #checkov:skip=CKV_AWS_356 - We must use a wildcard for the actions to allow AWS users the ability to manage the key
  #checkov:skip=CKV_AWS_111 - We must use a wildcard for the resources to avoid a circular dependency
  #checkov:skip=CKV_AWS_109 - We must use a wildcard for the resources to avoid a circular dependency
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  statement {
    sid    = "AllowKeyManagement"
    effect = "Allow"

    actions = [
      "kms:*",
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "AllowInspectorToUseKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "Service"
      identifiers = ["inspector2.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = concat(local.enabled_account_ids, [data.aws_caller_identity.current.account_id])
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        for account_id in concat(local.enabled_account_ids, [data.aws_caller_identity.current.account_id])
        : "arn:aws:inspector2:${data.aws_region.current.name}:${account_id}:report/*"
      ]
    }
  }
}

resource "aws_kms_alias" "export" {
  count = var.export_bucket_name != null && local.is_delegated_administrator_account ? 1 : 0

  name          = "alias/inspector-export"
  target_key_id = aws_kms_key.export[0].id
}
