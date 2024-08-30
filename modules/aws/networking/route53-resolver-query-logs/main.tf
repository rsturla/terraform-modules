locals {
  enable_s3_destination         = var.log_destination == "s3"
  enable_cloudwatch_destination = var.log_destination == "cloudwatch"

  create_s3_bucket = local.enable_s3_destination && var.s3_bucket_name != null

  log_destination_arn = coalesce(
    local.enable_s3_destination && local.create_s3_bucket ? aws_s3_bucket.logs[0].arn : null,
    local.enable_s3_destination && !local.create_s3_bucket ? var.existing_s3_bucket_arn : null,
    local.enable_cloudwatch_destination ? aws_cloudwatch_log_group.logs[0].arn : null
  )
}

resource "aws_route53_resolver_query_log_config" "this" {
  name            = "${var.name}-query-log"
  destination_arn = local.log_destination_arn

  tags = var.tags_all
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  for_each = toset(var.vpc_ids)

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this.id
  resource_id                  = each.value
}
