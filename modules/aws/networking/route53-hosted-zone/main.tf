resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = var.comment

  dynamic "vpc" {
    for_each = var.vpc_id != null ? ["vpc"] : []
    content {
      vpc_id = var.vpc_id
    }
  }

  tags = merge(var.tags_all, {
    "Name" = var.domain_name
  })
}

resource "aws_route53_query_log" "cloudwatch_query_logging" {
  count = var.enable_query_logs ? 1 : 0

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudwatch_query_logging[0].arn
  zone_id                  = aws_route53_zone.this.zone_id

  depends_on = [
    aws_cloudwatch_log_resource_policy.cloudwatch_query_logging[0],
  ]
}
