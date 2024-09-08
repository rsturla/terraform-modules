output "sns_topic_arn" {
  description = "The ARN of the SNS topic to use for budget notifications"
  value       = var.sns_topic_name != null && length(var.notifications) > 0 ? aws_sns_topic.notifications[0].arn : null
}
