data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  enable_s3_destination         = var.log_destination_type == "s3"
  enable_cloudwatch_destination = var.log_destination_type == "cloud-watch-logs"

  create_s3_bucket = local.enable_s3_destination && var.s3_bucket_name != null

  log_destination_arn = coalesce(
    local.enable_s3_destination && local.create_s3_bucket ? aws_s3_bucket.logs[0].arn : null,
    local.enable_s3_destination && !local.create_s3_bucket ? var.existing_s3_bucket_arn : null,
    local.enable_cloudwatch_destination ? aws_cloudwatch_log_group.logs[0].arn : null
  )
}

resource "aws_flow_log" "this" {
  vpc_id       = var.vpc_id
  traffic_type = var.traffic_type

  log_format               = var.log_format
  log_destination          = local.log_destination_arn
  log_destination_type     = var.log_destination_type
  max_aggregation_interval = var.max_aggregation_interval
  iam_role_arn             = local.enable_cloudwatch_destination ? aws_iam_role.cloudwatch[0].arn : null

  dynamic "destination_options" {
    for_each = var.destination_options != null ? [var.destination_options] : []
    content {
      file_format                = destination_options.value.file_format
      hive_compatible_partitions = destination_options.value.hive_compatible_partitions
      per_hour_partition         = destination_options.value.per_hour_partition
    }
  }

  tags = merge(var.tags_all, {
    Name = "${var.name}-flow-logs"
  })
}
