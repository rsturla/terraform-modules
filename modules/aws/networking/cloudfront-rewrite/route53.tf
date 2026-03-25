locals {
  source_urls = merge([
    for rewrite_key, rewrite_value in local.rewrites : {
      for source_domain in rewrite_value.source_domains :
      source_domain => {
        rewrite_key      = rewrite_key
        hosted_zone_name = rewrite_value.hosted_zone_name
      }
    }
  ]...)
}

resource "aws_route53_record" "record" {
  for_each = local.source_urls

  name    = each.key
  zone_id = data.aws_route53_zone.zone[each.value.rewrite_key].zone_id

  type = "A"
  alias {
    name                   = aws_cloudfront_distribution.distribution[each.value.rewrite_key].domain_name
    zone_id                = aws_cloudfront_distribution.distribution[each.value.rewrite_key].hosted_zone_id
    evaluate_target_health = false
  }
}
