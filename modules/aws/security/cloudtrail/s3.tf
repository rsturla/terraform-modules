locals {
  create_s3_bucket = var.create_s3_bucket && !var.is_organization_management_account ? true : false
}

resource "aws_s3_bucket" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket        = var.s3_bucket_name
  bucket_prefix = var.s3_bucket_name_prefix
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = data.aws_iam_policy_document.config_bucket_policy[0].json

  depends_on = [aws_s3_bucket_public_access_block.bucket]
}

data "aws_iam_policy_document" "config_bucket_policy" {
  count = local.create_s3_bucket ? 1 : 0

  statement {
    sid    = "AllowCloudTrailCheckAcl"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid    = "AllowCloudTrailWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.bucket[0].arn,
      "${aws_s3_bucket.bucket[0].arn}/AWSLogs/*",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid     = "AllowTLSRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.bucket[0].arn,
      "${aws_s3_bucket.bucket[0].arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
