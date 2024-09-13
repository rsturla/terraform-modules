data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "alarms" {
  name              = "${var.name}-rds-alarms"
  kms_master_key_id = "alias/aws/sns"
  tags              = var.tags_all
}

resource "aws_db_event_subscription" "alarms" {
  count = var.alarm_event_categories == null ? 0 : 1

  name             = "${var.name}-rds-alarms"
  sns_topic        = aws_sns_topic.alarms.arn
  source_type      = "db-instance"
  source_ids       = concat([aws_db_instance.primary.identifier], [for instance in aws_db_instance.replicas : instance.identifier])
  event_categories = var.alarm_event_categories

  tags = var.tags_all

  depends_on = [
    aws_sns_topic_policy.alarms,
  ]
}

resource "aws_sns_topic_policy" "alarms" {
  arn    = aws_sns_topic.alarms.arn
  policy = data.aws_iam_policy_document.sns_alarms.json
}

data "aws_iam_policy_document" "sns_alarms" {
  statement {
    sid    = "AllowSNSManagement"
    effect = "Allow"
    actions = [
      "SNS:Publish",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    resources = [aws_sns_topic.alarms.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "AWS:SourceOwner"
    }
  }

  statement {
    sid       = "AllowCloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alarms.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowRDSEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alarms.arn]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
