resource "aws_s3_bucket" "logs" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = var.s3_bucket_name
  tags   = var.tags_all
}

resource "aws_s3_bucket_public_access_block" "logs" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "logs" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id
  policy = data.aws_iam_policy_document.s3_policy[0].json
}

data "aws_iam_policy_document" "s3_policy" {
  count = local.create_s3_bucket ? 1 : 0

  statement {
    sid     = "AWSLogDeliveryWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      var.destination_options.hive_compatible_partitions ?
      "${aws_s3_bucket.logs[0].arn}/AWSLogs/aws-account-id=${data.aws_caller_identity.current.account_id}/*" :
      "${aws_s3_bucket.logs[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      aws_s3_bucket.logs[0].arn
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  statement {
    sid    = "EnforceProtocolVersion"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.logs[0].arn,
      "${aws_s3_bucket.logs[0].arn}/*"
    ]
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = ["1.2"]
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id

  rule {
    id     = "archive"
    status = "Enabled"

    transition {
      days          = var.s3_infrequent_access_transition_in_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.s3_glacier_transition_in_days
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_non_current_version_expiration_in_days
    }

    expiration {
      days = var.s3_log_retention_in_days
    }
  }

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
