variable "name" {
  type        = string
  description = "The name of the Route53 Resolver Query Log configuration"
}

variable "s3_bucket_name" {
  description = "The name of the new S3 bucket to store the query logs in."
  type        = string
  default     = null
}

variable "existing_s3_bucket_arn" {
  description = "The ARN of the existing S3 bucket to store the query logs in."
  type        = string
  default     = null
}

variable "log_destination" {
  description = "The query log destination. Valid values are s3 and cloudwatch."
  type        = string
  default     = "cloudwatch"
}

variable "cloudwatch_log_retention_in_days" {
  description = "The number of days to retain the CloudWatch logs for."
  type        = number
  default     = 90
}

variable "s3_glacier_transition_in_days" {
  description = "The number of days to transition the S3 logs to Glacier for."
  type        = number
  default     = 90
}

variable "s3_log_retention_in_days" {
  description = "The number of days to retain the S3 logs for."
  type        = number
  default     = 365
}

variable "s3_non_current_version_expiration_in_days" {
  description = "The number of days to expire non-current S3 object versions."
  type        = number
  default     = 30
}

variable "vpc_ids" {
  description = "The IDs of the VPCs to associate the Route53 Resolver Query Logs with."
  type        = list(string)
  default     = []
}

variable "tags_all" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}
