output "arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policy_arns" {
  description = "The ARNs of the IAM policies attached to the role"
  value       = aws_iam_role_policy_attachment.this[*].policy_arn
}
