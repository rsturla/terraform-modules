resource "aws_cloudwatch_log_group" "logs" {
  count = var.log_destination == "cloudwatch" ? 1 : 0

  name              = "${var.name}-route53-resolver-query-log"
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags              = var.tags_all
}
