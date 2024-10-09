variable "is_organization_management_account" {
  description = "Whether or not this account is the organization management account."
  type        = bool
  default     = false
}

variable "delegated_administrator_account_id" {
  description = "The delegated administrator to maintain the organization AWS Inspector configuration.  Only set this in the root (management) account."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the CloudTrail."
  type        = string
  default     = "cloudtrail"
}

variable "include_global_service_events" {
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files."
  type        = bool
  default     = true
}

variable "create_s3_bucket" {
  description = "Whether to create the S3 bucket or use an existing one."
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to which CloudTrail logs will be delivered."
  type        = string
  default     = null
}

variable "s3_bucket_name_prefix" {
  description = "The prefix for the specified S3 bucket."
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "The prefix for the specified S3 bucket."
  type        = string
  default     = null
}

variable "is_multi_region_trail" {
  description = "Specifies whether the trail is created in the current region or in all regions."
  type        = bool
  default     = true
}

variable "is_organization_trail" {
  description = "Specifies whether the trail is an AWS Organizations trail."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The KMS key ID to use to encrypt the logs.  If not defined, the default AWS managed key will be used."
  type        = string
  default     = null
}

variable "tags_all" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "insight_selector" {
  description = "A list of insight types to enable for the trail."
  type        = list(string)
  default     = []
}

variable "data_logging_enabled" {
  description = "Specifies whether data events are logged."
  type        = bool
  default     = false
}

variable "data_logging_read_write_type" {
  description = "Specifies the type of data events to log."
  type        = string
  default     = "All"
}

variable "data_logging_include_management_events" {
  description = "Specifies whether management events are logged."
  type        = bool
  default     = true
}

variable "data_logging_resources" {
  description = "A map of data resources to log."
  type        = map(list(string))
  default     = {}
}

variable "advanced_event_selectors" {
  description = "A map of advanced event selectors."
  type        = any
  default     = {}
}
