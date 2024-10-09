resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  bucket_prefix = var.bucket_name_prefix
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.config_bucket_policy.json

  depends_on = [aws_s3_bucket_public_access_block.bucket]
}

data "aws_iam_policy_document" "config_bucket_policy" {
  statement {
    sid    = "AllowCloudTrailCheckAcl"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.cloudtrail_arn != null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:SourceArn"
        values   = [var.cloudtrail_arn]
      }
    }
  }

  statement {
    sid    = "AllowCloudTrailWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/AWSLogs/*",
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
    dynamic "condition" {
      for_each = var.cloudtrail_arn != null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:SourceArn"
        values   = [var.cloudtrail_arn]
      }
    }
  }

  statement {
    sid     = "AllowTLSRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
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
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = var.infrequent_access_transition_days != null ? [1] : []

    content {
      id     = "transition-to-standard-ia"
      status = "Enabled"

      transition {
        days          = var.infrequent_access_transition_days
        storage_class = "STANDARD_IA"
      }

      filter {
        prefix = var.lifecycle_prefix
      }
    }
  }

  dynamic "rule" {
    for_each = var.glacier_transition_days != null ? [1] : []

    content {
      id     = "transition-to-glacier"
      status = "Enabled"

      transition {
        days          = var.glacier_transition_days
        storage_class = "GLACIER"
      }

      filter {
        prefix = var.lifecycle_prefix
      }
    }
  }

  rule {
    id     = "expire-objects"
    status = "Enabled"

    expiration {
      days = var.expiration_days
    }

    filter {
      prefix = var.lifecycle_prefix
    }
  }

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    filter {
      prefix = var.lifecycle_prefix
    }
  }
}
