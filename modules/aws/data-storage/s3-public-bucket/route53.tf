data "aws_route53_zone" "this" {
  for_each = local.domains

  name = each.value.hosted_zone_name
}

resource "aws_route53_record" "this" {
  for_each = local.domains

  zone_id = data.aws_route53_zone.this[each.key].zone_id
  name    = each.value.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.this[each.key].hosted_zone_id
    evaluate_target_health = false
  }
}
