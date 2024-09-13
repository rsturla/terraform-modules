data "aws_route53_zone" "zone" {
  count = var.dns_zone_name != null ? 1 : 0

  name = var.dns_zone_name
}

resource "aws_route53_record" "primary" {
  count = var.dns_zone_name != null && var.dns_record_name != null ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = var.dns_record_name
  type    = "CNAME"
  ttl     = 600
  records = [aws_db_instance.primary.address]
}

resource "aws_route53_record" "replicas" {
  for_each = var.dns_zone_name != null && var.dns_record_name != null ? var.read_replicas : {}

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = lower("${each.key}.${var.dns_record_name}.${var.dns_zone_name}")
  type    = "CNAME"
  ttl     = 600
  records = [aws_db_instance.replicas[each.key].address]
}
