output "vault_arns" {
  description = "The ARNs of the Backup vaults"
  value = {
    for vault_name, conf in aws_backup_vault.this : vault_name => aws_backup_vault.this[vault_name].arn
  }
}

output "vault_names" {
  description = "The names of the Backup vaults"
  value = {
    for vault_name, conf in aws_backup_vault.this : vault_name => aws_backup_vault.this[vault_name].name
  }
}

output "sns_topic_arns" {
  description = "A list of the ARNs for any SNS topics that may have been created to support Backup vault notifications"
  value = {
    for sns_topic, conf in aws_sns_topic.notifications : sns_topic => aws_sns_topic.notifications[sns_topic].arn
  }
}
