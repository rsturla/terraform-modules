output "name" {
  description = "The name of the CloudTrail Trail."
  value       = aws_cloudtrail.this[0].name
}

output "arn" {
  description = "The ARN of the CloudTrail Trail."
  value       = aws_cloudtrail.this[0].arn
}

output "bucket_name" {
  description = "The name of the S3 bucket to which CloudTrail logs will be delivered."
  value       = try(module.bucket[0].bucket_name, null)
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket to which CloudTrail logs will be delivered."
  value       = try(module.bucket[0].arn, null)
}
