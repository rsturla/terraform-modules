resource "aws_s3_bucket" "this" {
  bucket = var.name

  tags = var.tags_all
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "this" {
  count      = var.bucket_acl != null ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  acl        = var.bucket_acl
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.bucket_ownership
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.access_logging_bucket_id != null ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_logging_bucket_id

  target_prefix = var.access_logging_prefix != null ? var.access_logging_prefix : "${aws_s3_bucket.this.bucket}/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.sse_algorithm != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status     = var.enable_versioning ? "Enabled" : "Suspended"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_analytics_configuration" "analytics_configuration" {
  bucket = aws_s3_bucket.this.id
  name   = "analytics-${var.name}"
  dynamic "filter" {
    for_each = var.bucket_analytics_prefix != null ? [var.bucket_analytics_prefix] : []
    content {
      prefix = var.bucket_analytics_prefix
    }
  }
  dynamic "storage_class_analysis" {
    for_each = var.bucket_analytics_destination_bucket_config != null ? [var.bucket_analytics_destination_bucket_config] : []
    content {
      data_export {
        destination {
          s3_bucket_destination {
            bucket_arn        = storage_class_analysis.value.bucket_arn
            format            = "CSV"
            bucket_account_id = storage_class_analysis.value.bucket_account_id
            prefix            = aws_s3_bucket.this.id
          }
        }
        output_schema_version = "V_1"
      }
    }
  }
}
