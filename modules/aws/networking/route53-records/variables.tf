variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone to create records in."
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, null)
    records = optional(list(string), null)
    weighted_routing_policy = optional(object({
      weight = number
    }), null)
    set_identifier = optional(string, null)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }), null)
  }))
  description = "A list of records to create in the hosted zone."
}
