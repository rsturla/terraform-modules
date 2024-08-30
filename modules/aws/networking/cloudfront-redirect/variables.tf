variable "redirects" {
  type = list(object({
    source_domains      = list(string)
    target_url          = string
    status_code         = optional(number, 301)
    hosted_zone_name    = string
    ssl_certificate_arn = string
  }))
  description = "A list of redirects to create"
}

variable "tags_all" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}
