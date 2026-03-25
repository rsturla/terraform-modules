output "distribution_arns" {
  value = {
    for rewrite_key, rewrite_value in local.rewrites : rewrite_key => aws_cloudfront_distribution.distribution[rewrite_key].arn
  }
}

output "distribution_ids" {
  value = {
    for rewrite_key, rewrite_value in local.rewrites : rewrite_key => aws_cloudfront_distribution.distribution[rewrite_key].id
  }
}

output "distribution_domain_names" {
  value = {
    for rewrite_key, rewrite_value in local.rewrites : rewrite_key => aws_cloudfront_distribution.distribution[rewrite_key].domain_name
  }
  description = "CloudFront domain names for creating external DNS records (CNAME)"
}
