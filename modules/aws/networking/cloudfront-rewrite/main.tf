data "aws_route53_zone" "zone" {
  for_each = local.rewrites

  name = each.value.hosted_zone_name
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

locals {
  rewrites = {
    for rewrite in var.rewrites : replace(rewrite.source_domains[0], ".", "_") => rewrite
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  for_each = local.rewrites

  enabled = true
  comment = "Rewrite ${each.value.source_domains[0]} -> ${each.value.target_domain}"
  aliases = each.value.source_domains

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = each.value.target_domain
    origin_id           = each.key

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = each.key
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = each.value.cache_policy_id != null ? each.value.cache_policy_id : data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = each.value.ssl_certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = var.tags_all
}
