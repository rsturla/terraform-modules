variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
  default     = null
}

variable "bucket_name_prefix" {
  description = "The prefix of the bucket"
  type        = string
  default     = null
}

variable "lifecycle_prefix" {
  description = "The prefix to use for lifecycle rules"
  type        = string
  default     = null
}

variable "infrequent_access_transition_days" {
  type        = number
  description = "The number of days to wait before transitioning objects to the STANDARD_IA storage class.  Defaults to 30 days."
  default     = 30
}

variable "glacier_transition_days" {
  type        = number
  description = "The number of days to wait before transitioning objects to the GLACIER storage class.  Defaults to 90 days."
  default     = 90
}

variable "expiration_days" {
  type        = number
  description = "The number of days to wait before permanently deleting objects.  Defaults to 10 years."
  default     = 3650
}

variable "cloudtrail_arn" {
  description = "The ARN of the CloudTrail to allow access to the bucket"
  type        = string
  default     = null
}
