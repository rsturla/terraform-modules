variable "bucket_name" {
  type        = string
  description = "The name of the bucket to create which will serve the static content"
}

variable "tags_all" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all resources created by this module"
}

variable "domains" {
  type = list(object({
    domain              = string
    directory           = optional(string, null)
    acm_certificate_arn = string
    hosted_zone_name    = string
    default_ttl         = optional(number, 3600)
    default_root_object = optional(string, null)
  }))
  description = "A map of domains to host on the bucket"
}

variable "bucket_version_management" {
  type = map(object({
    filter = optional(object({
      prefix = string
    }), null)
    noncurrent_version_expiration_days = optional(number, null)
    noncurrent_version_transition = optional(object({
      days          = number
      storage_class = string
    }), null)
    expiration = optional(object({
      days = number
    }), null)
    transition = optional(object({
      days          = number
      storage_class = string
    }), null)
  }))
  description = "Number of days after which to expire non current objects."
  default = {
    "expire-noncurrent-version" = {
      filter                             = null
      noncurrent_version_expiration_days = 30
      noncurrent_version_transition      = null
      expiration                         = null
      transition                         = null
    }
  }
}

variable "access_logging_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to which to send access logs.  If not provided, access logging will be disabled."
  default     = null
}

variable "access_logging_prefix" {
  type        = string
  description = "The prefix to use for access logs."
  default     = null
}

variable "logging_config_s3_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to which to send CloudFront logs.  If not provided, logging will be disabled."
  default     = null
}

variable "cloudfront_response_headers_policy" {
  description = "Configuration for AWS CloudFront response headers policy."

  type = map(object({
    cors_config = object({
      access_control_allow_credentials = bool
      access_control_allow_headers     = optional(list(string))
      access_control_allow_origins     = optional(list(string))
      access_control_allow_methods     = optional(list(string))
      access_control_expose_headers    = optional(list(string))
      access_control_max_age_sec       = optional(number)
      origin_override                  = optional(bool)
    })
    custom_headers_config = object({
      header   = optional(string)
      value    = optional(string)
      override = optional(bool)
    })
    remove_headers_config = object({
      items = optional(list(string))
    })
    security_headers_config = object({
      content_security_policy = object({
        policy   = optional(string)
        override = optional(bool)
      })
      content_type_options = object({
        override = optional(bool)
      })
      frame_options = object({
        frame_option = optional(string)
        override     = optional(bool)
      })
      referrer_policy = object({
        policy   = optional(string)
        override = optional(bool)
      })
      strict_transport_security = object({
        access_control_max_age_sec = optional(number)
        include_subdomains         = optional(bool)
        preload                    = optional(bool)
        override                   = optional(bool)
      })
      xss_protection = object({
        mode_block = optional(string)
        override   = optional(bool)
        protection = optional(string)
        report_uri = optional(string)
      })
    })
    server_timing_headers_config = object({
      enabled       = optional(bool)
      sampling_rate = optional(number)
    })
  }))
  default = null
}
