output "name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.bucket.arn
}
