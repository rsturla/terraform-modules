variable "rewrites" {
  type = list(object({
    source_domains      = list(string)
    target_domain       = string
    hosted_zone_name    = optional(string, null)
    ssl_certificate_arn = string
    cache_policy_id     = optional(string, null)
  }))
  description = "A list of domain rewrites (reverse proxies) to create"
}

variable "manage_dns" {
  type        = bool
  default     = true
  description = "Whether to create Route53 DNS records. Set to false when DNS is managed externally."
}

variable "robots_txt_disallow" {
  type        = bool
  default     = false
  description = "Whether to serve a robots.txt that disallows all crawlers via a CloudFront Function."
}

variable "tags_all" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}
