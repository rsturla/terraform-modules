resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags_all
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.cloudfront_bucket_policy.json
}

data "aws_iam_policy_document" "cloudfront_bucket_policy" {
  statement {
    sid     = "AllowTLSRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
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

  dynamic "statement" {
    for_each = local.domains

    content {
      actions = ["s3:GetObject"]
      resources = statement.value.directory != null ? [
        "${aws_s3_bucket.this.arn}/public/${trimprefix(statement.value.directory, "/")}/*",
        ] : [
        "${aws_s3_bucket.this.arn}/public/*",
      ]

      principals {
        type        = "Service"
        identifiers = ["cloudfront.amazonaws.com"]
      }
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceArn"
        values   = [aws_cloudfront_distribution.this[statement.key].arn]
      }
    }
  }
}

resource "aws_s3_bucket_logging" "bucket" {
  count = var.access_logging_bucket_id != null ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_logging_bucket_id

  target_prefix = var.access_logging_prefix != null ? var.access_logging_prefix : "${aws_s3_bucket.this.bucket}/"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.id
  key    = "public/"
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_version_management" {
  for_each = length(var.bucket_version_management) > 0 ? var.bucket_version_management : {}
  bucket   = aws_s3_bucket.this.id

  rule {
    id     = "expire-noncurrent-version"
    status = "Enabled"

    dynamic "filter" {
      for_each = each.value.filter != null ? [1] : []
      content {
        prefix = each.value.filter.prefix
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = each.value.noncurrent_version_expiration_days != null ? [1] : []
      content {
        noncurrent_days = each.value.noncurrent_version_expiration_days
      }
    }
    dynamic "noncurrent_version_transition" {
      for_each = each.value.noncurrent_version_transition != null ? [1] : []
      content {
        noncurrent_days = each.value.noncurrent_version_transition.days
        storage_class   = each.value.noncurrent_version_transition.storage_class
      }
    }
    dynamic "expiration" {
      for_each = each.value.expiration != null ? [1] : []
      content {
        days = each.value.expiration.days
      }
    }
    dynamic "transition" {
      for_each = each.value.transition != null ? [1] : []
      content {
        days          = each.value.transition.days
        storage_class = each.value.transition.storage_class
      }
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
