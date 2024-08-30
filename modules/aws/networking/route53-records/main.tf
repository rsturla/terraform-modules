locals {
  records = {
    for r in var.records :
    join("_", concat(
      [var.zone_id, r.name, r.type],
      (r.set_identifier != null ? [r.set_identifier] : [])
    )) => r
  }
}

resource "aws_route53_record" "this" {
  for_each = local.records

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "weighted_routing_policy" {
    for_each = each.value.weighted_routing_policy != null ? [each.value.weighted_routing_policy] : []
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  set_identifier = each.value.set_identifier
  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
