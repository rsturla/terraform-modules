variable "rewrites" {
  type = list(object({
    source_domains      = list(string)
    target_domain       = string
    hosted_zone_name    = string
    ssl_certificate_arn = string
    cache_policy_id     = optional(string, null)
  }))
  description = "A list of domain rewrites (reverse proxies) to create"
}

variable "tags_all" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}
