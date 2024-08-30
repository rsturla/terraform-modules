locals {
  default_root_object = {
    for domain in var.domains : domain.domain =>
    domain.default_root_object != null ? domain.default_root_object : "index.html"
  }
  domains = {
    for domain in var.domains : domain.domain => domain
  }
}

resource "aws_cloudfront_distribution" "this" {
  for_each = local.domains

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${each.value.domain}"
  aliases             = [each.value.domain]
  default_root_object = local.default_root_object[each.key]

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.this.id
    origin_path              = each.value.directory != null ? "/public/${trimprefix(each.value.directory, "/")}" : "/public"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.this.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = each.value.default_ttl
    max_ttl                    = 86400 # 1 day
    response_headers_policy_id = var.cloudfront_response_headers_policy != null ? aws_cloudfront_response_headers_policy.this[each.key].id : null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = each.value.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  dynamic "logging_config" {
    for_each = var.logging_config_s3_bucket_id != null ? [1] : []
    content {
      bucket = var.logging_config_s3_bucket_id
    }
  }

  tags = var.tags_all
}

resource "aws_cloudfront_response_headers_policy" "this" {
  for_each = var.cloudfront_response_headers_policy != null ? local.domains : {}
  name     = "response-headers-policy"

  dynamic "cors_config" {
    for_each = var.cloudfront_response_headers_policy.cors_config != null ? [1] : []
    content {
      access_control_allow_credentials = cors_config.value.access_control_allow_credentials
      dynamic "access_control_allow_headers" {
        for_each = cors_config.value.access_control_allow_headers != null ? [1] : []
        content {
          items = cors_config.value.access_control_allow_headers
        }

      }
      dynamic "access_control_allow_origins" {
        for_each = cors_config.value.access_control_allow_origins != null ? [1] : []
        content {
          items = cors_config.value.access_control_allow_origins
        }
      }

      dynamic "access_control_allow_methods" {
        for_each = cors_config.value.access_control_allow_methods != null ? [1] : []
        content {
          items = cors_config.value.access_control_allow_methods
        }
      }

      dynamic "access_control_expose_headers" {
        for_each = cors_config.value.access_control_expose_headers != null ? [1] : []
        content {
          items = cors_config.value.access_control_expose_headers
        }
      }
      access_control_max_age_sec = cors_config.value.access_control_max_age_sec
      origin_override            = cors_config.value.origin_override
    }
  }

  dynamic "custom_headers_config" {
    for_each = var.cloudfront_response_headers_policy.custom_headers_config != null ? [1] : []
    content {
      items {
        header   = custom_headers_config.value.header
        value    = custom_headers_config.value.value
        override = custom_headers_config.value.override
      }
    }
  }

  dynamic "security_headers_config" {
    for_each = var.cloudfront_response_headers_policy.security_headers_config != null ? [1] : []
    content {
      dynamic "content_security_policy" {
        for_each = security_headers_config.value.content_security_policy != null ? [1] : []
        content {
          content_security_policy = content_security_policy.value.policy
          override                = content_security_policy.value.override
        }

      }

      dynamic "content_type_options" {
        for_each = security_headers_config.value.content_type_options != null ? [1] : []
        content {
          override = content_type_options.value.override
        }
      }
      dynamic "frame_options" {
        for_each = security_headers_config.value.frame_options != null ? [1] : []
        content {
          frame_option = frame_options.value.frame_option
          override     = frame_options.value.override
        }
      }
      dynamic "referrer_policy" {
        for_each = security_headers_config.value.referrer_policy != null ? [1] : []
        content {
          referrer_policy = referrer_policy.value.policy
          override        = referrer_policy.value.override
        }
      }
      dynamic "strict_transport_security" {
        for_each = security_headers_config.value.strict_transport_security != null ? [1] : []
        content {
          access_control_max_age_sec = strict_transport_security.value.access_control_max_age_sec
          include_subdomains         = strict_transport_security.value.include_subdomains
          preload                    = strict_transport_security.value.preload
          override                   = strict_transport_security.value.override
        }
      }

      dynamic "xss_protection" {
        for_each = security_headers_config.value.xss_protection != null ? [1] : []
        content {
          mode_block = xss_protection.value.mode_block
          override   = xss_protection.value.override
          protection = xss_protection.value.protection
          report_uri = xss_protection.value.report_uri
        }
      }
    }
  }
  dynamic "server_timing_headers_config" {
    for_each = var.cloudfront_response_headers_policy.server_timing_headers_config != null ? [1] : []
    content {
      enabled       = server_timing_headers_config.value.enabled
      sampling_rate = server_timing_headers_config.value.sampling_rate
    }
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = aws_s3_bucket.this.id
  description                       = "Origin Access Identity for ${aws_s3_bucket.this.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
