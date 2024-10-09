data "aws_caller_identity" "current" {}

locals {
  is_delegated_administrator_account = var.delegated_administrator_account_id == data.aws_caller_identity.current.account_id
}

resource "aws_cloudtrail_organization_delegated_admin_account" "this" {
  count = var.is_organization_management_account && var.delegated_administrator_account_id != null ? 1 : 0

  account_id = var.delegated_administrator_account_id
}

resource "aws_cloudtrail" "this" {
  count = local.is_delegated_administrator_account || var.delegated_administrator_account_id == null ? 1 : 0

  name = var.name

  s3_bucket_name = var.create_s3_bucket ? module.bucket[0].name : var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix
  kms_key_id     = var.kms_key_id

  include_global_service_events = true
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail

  enable_log_file_validation = true

  dynamic "insight_selector" {
    for_each = toset(var.insight_selector)

    content {
      insight_type = insight_selector.value
    }
  }

  dynamic "event_selector" {
    for_each = var.data_logging_enabled ? ["once"] : []

    content {
      read_write_type           = var.data_logging_read_write_type
      include_management_events = var.data_logging_include_management_events

      dynamic "data_resource" {
        for_each = var.data_logging_resources

        content {
          type   = data_resource.key
          values = data_resource.value
        }
      }
    }
  }

  dynamic "advanced_event_selector" {
    for_each = var.advanced_event_selectors

    content {
      name = advanced_event_selector.key

      dynamic "field_selector" {
        for_each = advanced_event_selector.value

        content {
          field           = field_selector.value.field
          equals          = lookup(field_selector.value, "equals", null)
          not_equals      = lookup(field_selector.value, "not_equals", null)
          starts_with     = lookup(field_selector.value, "starts_with", null)
          not_starts_with = lookup(field_selector.value, "not_starts_with", null)
          ends_with       = lookup(field_selector.value, "ends_with", null)
          not_ends_with   = lookup(field_selector.value, "not_ends_with", null)
        }
      }
    }
  }

  tags = var.tags_all

  depends_on = [
    module.bucket,
  ]
}

module "bucket" {
  source = "./bucket"
  count  = var.create_s3_bucket ? 1 : 0

  bucket_name        = var.s3_bucket_name
  bucket_name_prefix = var.s3_bucket_name_prefix
  lifecycle_prefix   = var.s3_key_prefix
}
