output "distribution_ids" {
  value = {
    for domain in local.domains : domain.domain => aws_cloudfront_distribution.this[domain.domain].id
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
