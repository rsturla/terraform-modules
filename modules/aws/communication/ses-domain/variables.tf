variable "email_identity" {
  type        = string
  description = "The email identity to allow sending emails from.  Can be a domain or email address."
}

variable "tags_all" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources created by this module."
}

variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID to add the DKIM record to.  If not provided, no DKIM record will be created."
  default     = null
}

variable "identity_policies" {
  type        = any
  description = "A map of SES identity policies to apply to the email identity."
  default     = {}
}
