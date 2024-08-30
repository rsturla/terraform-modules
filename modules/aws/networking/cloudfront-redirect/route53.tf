locals {
  source_urls = merge([
    for redirect_key, redirect_value in local.redirects : {
      for source_domain in redirect_value.source_domains :
      source_domain => {
        redirect_key     = redirect_key
        target_url       = redirect_value.target_url
        status_code      = redirect_value.status_code
        hosted_zone_name = redirect_value.hosted_zone_name
      }
    }
  ]...)
}

resource "aws_route53_record" "record" {
  for_each = local.source_urls

  name    = each.key
  zone_id = data.aws_route53_zone.zone[each.value.redirect_key].zone_id

  type = "A"
  alias {
    name                   = aws_cloudfront_distribution.distribution[each.value.redirect_key].domain_name
    zone_id                = aws_cloudfront_distribution.distribution[each.value.redirect_key].hosted_zone_id
    evaluate_target_health = false
  }
}
