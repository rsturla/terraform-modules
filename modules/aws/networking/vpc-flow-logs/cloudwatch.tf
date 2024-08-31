resource "aws_cloudwatch_log_group" "logs" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  name              = "/aws/vpc/${var.name}-flow-logs"
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = var.tags_all
}

resource "aws_iam_role" "cloudwatch" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  name_prefix        = "${var.name}-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role[0].json

  tags = var.tags_all
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  role       = aws_iam_role.cloudwatch[0].name
  policy_arn = aws_iam_policy.cloudwatch_iam_policy[0].arn
}

resource "aws_iam_policy" "cloudwatch_iam_policy" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  name_prefix = "allow-publish-flow-logs-"
  policy      = data.aws_iam_policy_document.cloudwatch_iam_policy[0].json

  tags = var.tags_all
}

data "aws_iam_policy_document" "cloudwatch_assume_role" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_iam_policy" {
  count = local.enable_cloudwatch_destination ? 1 : 0

  statement {
    sid    = "AllowPublishToCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.logs[0].arn}:*"]
  }
}
