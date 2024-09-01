resource "aws_backup_vault_notifications" "notifications" {
  for_each            = local.vaults_with_notifications
  backup_vault_name   = each.key
  sns_topic_arn       = aws_sns_topic.notifications[each.key].arn
  backup_vault_events = each.value.events_to_listen_for
}

resource "aws_sns_topic" "notifications" {
  for_each          = local.vaults_with_notifications
  name              = "${each.key}-events"
  kms_master_key_id = var.create_kms_key ? aws_kms_key.backup[0].arn : "alias/aws/sns"

  tags = merge(
    var.tags_all,
    each.value.tags,
  )
}

resource "aws_sns_topic_policy" "notifications" {
  for_each = local.vaults_with_notifications
  arn      = aws_sns_topic.notifications[each.key].arn
  policy   = data.aws_iam_policy_document.notifications[each.key].json
}

data "aws_iam_policy_document" "notifications" {
  for_each = local.vaults_with_notifications

  statement {
    sid = "BackupPublishEvents"

    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.notifications[each.key].arn,
    ]
  }
}
