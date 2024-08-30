variable "name" {
  description = "The name of the bucket"
  type        = string
}

variable "tags_all" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "bucket_acl" {
  description = "The canned ACL to apply. Defaults to private."
  type        = string
  default     = null
}

variable "bucket_ownership" {
  type        = string
  description = "The AWS account ID of the owner of the bucket.  If provided, the bucket will be configured to use bucket owner granting."
  default     = "BucketOwnerEnforced"
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

variable "sse_algorithm" {
  type        = string
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms."
  default     = "AES256"
}

variable "bucket_key_enabled" {
  type        = bool
  description = "Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using AWS KMS (SSE-KMS)."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to use for server-side encryption. If not provided, the default aws/s3 key will be used."
  default     = null
}

variable "enable_versioning" {
  type        = bool
  description = "Whether to enable versioning. If enabled, instead of overriding objects, the S3 bucket will always create a new version of each object, so all the old values are retained."
  default     = true
}

variable "bucket_policy_statements" {
  type        = any
  description = "The IAM policy to apply to this S3 bucket. You can use this to grant read/write access. This should be a map, where each key is a unique statement ID (SID), and each value is an object that contains the parameters defined in the comment above."
  default     = {}
}

variable "expire_noncurrent_objects_days" {
  type        = number
  description = "Number of days after which to expire non current objects."
  default     = 14
}

variable "lifecycle_rules" {
  type        = any
  description = "Lifecycle rules to set on this S3 bucket"
  default     = {}
}

variable "bucket_analytics_prefix" {
  type        = string
  description = "S3 Prefix for Applying Bucket Analytics Configuration. If not supplied, the entire bucket will be analyzed."
  default     = null
}

variable "bucket_analytics_destination_bucket_config" {
  type = object({
    bucket_arn        = string
    bucket_account_id = optional(string, null)
  })
  description = "Configuration for S3 Bucket Analytics destination bucket."
  default     = null
}
