data "aws_route53_zone" "zone" {
  for_each = local.redirects

  name = each.value.hosted_zone_name
}

locals {
  default_root_object_prefix = "domain-redirect-"

  status_code_descriptions = {
    301 = "Moved Permanently"
    302 = "Found"
  }

  redirects = {
    for redirect in var.redirects : replace(redirect.source_domains[0], ".", "_") => redirect
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  for_each = local.redirects

  enabled             = true
  comment             = "Redirect ${each.value.source_domains[0]} to ${each.value.target_url}"
  default_root_object = "${local.default_root_object_prefix}${each.value.source_domains[0]}"
  aliases             = each.value.source_domains

  origin {
    connection_attempts = 3
    connection_timeout  = 2
    domain_name         = each.value.source_domains[0]
    origin_id           = each.key

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = each.key
    viewer_protocol_policy = "redirect-to-https"
    compress               = false

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect[each.key].arn
    }
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

resource "aws_cloudfront_function" "redirect" {
  for_each = local.redirects

  name = "${each.key}-redirect"
  # Remove the https:// from the target URL
  comment = "Redirect ${each.key} to ${trimprefix(each.value.target_url, "https://")}"
  runtime = "cloudfront-js-1.0"

  code = templatefile("${path.module}/redirect.js.tpl", {
    redirect_url                = each.value.target_url
    redirect_status_code        = each.value.status_code
    redirect_status_description = local.status_code_descriptions[each.value.status_code]
  })

  lifecycle {
    # Functions cannot be destroyed if they are still associated with a distribution
    create_before_destroy = true
  }
}
