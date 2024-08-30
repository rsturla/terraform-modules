output "records" {
  description = "The records created in the hosted zone."
  value = {
    for k, r in local.records :
    k => {
      name    = r.name
      type    = r.type
      ttl     = try(r.ttl, null)
      records = try(r.records, null)
      weighted_routing_policy = try({
        weight = r.weighted_routing_policy[0].weight
      }, null)
      set_identifier = try(r.set_identifier, null)
      alias = try({
        name                   = r.alias[0].name
        zone_id                = r.alias[0].zone_id
        evaluate_target_health = r.alias[0].evaluate_target_health
      }, null)
    }
  }
}
