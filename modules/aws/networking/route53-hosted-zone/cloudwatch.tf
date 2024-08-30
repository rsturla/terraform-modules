resource "aws_cloudwatch_log_group" "cloudwatch_query_logging" {
  count    = var.enable_query_logs ? 1 : 0
  provider = aws.us_east_1

  name              = "/aws/route53/${var.domain_name}"
  retention_in_days = var.cloudwatch_logs_retention_days

  tags = var.tags_all
}

data "aws_iam_policy_document" "cloudwatch_query_logging" {
  count = var.enable_query_logs ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/route53/*",
    ]

    principals {
      type = "Service"
      identifiers = [
        "route53.amazonaws.com",
      ]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_query_logging" {
  count    = var.enable_query_logs ? 1 : 0
  provider = aws.us_east_1

  policy_document = data.aws_iam_policy_document.cloudwatch_query_logging[0].json
  policy_name     = "route53-cloudwatch-query-logging"
}
