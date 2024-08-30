resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.key
      status = lookup(rule.value, "enabled", true) == true ? "Enabled" : "Disabled"

      dynamic "filter" {
        for_each = lookup(rule.value, "prefix", null) != null ? [lookup(rule.value, "prefix")] : []
        content {
          prefix = filter.value
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", {})
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", {})
        content {
          storage_class = lookup(transition.value, "storage_class")
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
        }
      }
    }
  }

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = var.expire_noncurrent_objects_days
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
