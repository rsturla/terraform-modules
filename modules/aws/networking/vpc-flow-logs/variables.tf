variable "name" {
  description = "The name of the flow log."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"
}

variable "log_destination_type" {
  description = "The type of destination to which the flow log data is published. Valid values: cloud-watch-logs, s3."
  type        = string
  default     = "cloud-watch-logs"
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear. For a list of available fields, see Flow log record format - https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html#flow-log-records"
  type        = string
  default     = null
}

variable "max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: 60 seconds (1 minute) or 600 seconds (10 minutes)."
  type        = number
  default     = 600
}

variable "destination_options" {
  description = "Destination options for flow log delivery. For more information, see Flow log delivery options - https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html#flow-log-destinations"
  type = object({
    file_format                = optional(string, null)
    hive_compatible_partitions = optional(bool, null)
    per_hour_partition         = optional(bool, null)
  })
  default = null
}

variable "s3_bucket_name" {
  description = "The name of a new S3 bucket to which the flow log data should be published."
  type        = string
  default     = null
}

variable "existing_s3_bucket_arn" {
  description = "The ARN of an existing S3 bucket to which the flow log data should be published."
  type        = string
  default     = null
}

variable "s3_infrequent_access_transition_in_days" {
  description = "The number of days to retain log events in the specified S3 bucket for infrequent access. Valid values: 1-3650."
  type        = number
  default     = 30
}

variable "s3_glacier_transition_in_days" {
  description = "The number of days to retain log events in the specified S3 bucket for Glacier transition. Valid values: 1-3650."
  type        = number
  default     = 180
}

variable "s3_log_retention_in_days" {
  description = "The number of days to retain log events in the specified S3 bucket. Valid values: 1-3650."
  type        = number
  default     = 365
}

variable "s3_non_current_version_expiration_in_days" {
  description = "The number of days to expire non-current S3 object versions."
  type        = number
  default     = 30
}

# CloudWatch is designed for short-term retention of log events. For long-term retention, export log events to S3.
variable "cloudwatch_log_retention_in_days" {
  description = "The number of days to retain log events in the specified CloudWatch log group. Valid values: 1-3650."
  type        = number
  default     = 30
}


variable "tags_all" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
