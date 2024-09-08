data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "this" {
  for_each = var.budgets

  name              = each.key
  budget_type       = each.value.budget_type
  limit_amount      = each.value.limit_amount
  limit_unit        = lookup(each.value, "limit_unit", "USD")
  time_period_start = lookup(each.value, "time_period_start", null)
  time_period_end   = lookup(each.value, "time_period_end", null)
  time_unit         = lookup(each.value, "time_unit", "MONTHLY")

  dynamic "cost_types" {
    for_each = lookup(each.value, "cost_types", null) != null ? [each.value.cost_types] : []

    content {
      include_credit             = lookup(cost_types.value, "include_credit", null)
      include_discount           = lookup(cost_types.value, "include_discount", null)
      include_other_subscription = lookup(cost_types.value, "include_other_subscription", null)
      include_recurring          = lookup(cost_types.value, "include_recurring", null)
      include_refund             = lookup(cost_types.value, "include_refund", null)
      include_subscription       = lookup(cost_types.value, "include_subscription", null)
      include_support            = lookup(cost_types.value, "include_support", null)
      include_tax                = lookup(cost_types.value, "include_tax", null)
      include_upfront            = lookup(cost_types.value, "include_upfront", null)
      use_blended                = lookup(cost_types.value, "use_blended", null)
    }
  }

  dynamic "cost_filter" {
    for_each = toset(each.value.cost_filter)

    content {
      name   = cost_filter.value.name
      values = cost_filter.value.values
    }
  }

  dynamic "notification" {
    for_each = var.notifications != null ? toset(var.notifications) : []

    content {
      comparison_operator        = notification.value.comparison_operator
      notification_type          = notification.value.notification_type
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      subscriber_email_addresses = notification.value.subscriber_email_addresses
      subscriber_sns_topic_arns = concat(
        var.sns_topic_name != null && length(var.notifications) > 0 ? [aws_sns_topic.notifications[0].arn] : [],
        notification.value.subscriber_sns_topic_arns,
      )
    }
  }

  tags = merge(
    var.tags_all,
    each.value.tags
  )
}

resource "aws_sns_topic" "notifications" {
  count = var.sns_topic_name != null && length(var.notifications) > 0 ? 1 : 0
  name  = var.sns_topic_name
  tags  = var.tags_all
}

resource "aws_sns_topic_policy" "notifications" {
  count = var.sns_topic_name != null && length(var.notifications) > 0 ? 1 : 0

  arn    = aws_sns_topic.notifications[0].arn
  policy = data.aws_iam_policy_document.notifications[0].json
}

data "aws_iam_policy_document" "notifications" {
  count = var.sns_topic_name != null && length(var.notifications) > 0 ? 1 : 0

  statement {
    sid    = "__default_statement_ID"
    effect = "Allow"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.notifications[0].arn,
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
  }

  statement {
    sid    = "AllowAWSBudgetsPublish"
    effect = "Allow"
    actions = [
      "sns:Publish",
    ]
    resources = [
      aws_sns_topic.notifications[0].arn,
    ]
    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*",
      ]
    }
  }
}
