output "distribution_arns" {
  value = {
    for redirect_key, redirect_value in local.redirects : redirect_key => aws_cloudfront_distribution.distribution[redirect_key].arn
  }
}

output "distribution_ids" {
  value = {
    for redirect_key, redirect_value in local.redirects : redirect_key => aws_cloudfront_distribution.distribution[redirect_key].id
  }
}

output "function_arns" {
  value = {
    for redirect_key, redirect_value in local.redirects : redirect_key => aws_cloudfront_function.redirect[redirect_key].arn
  }
}
