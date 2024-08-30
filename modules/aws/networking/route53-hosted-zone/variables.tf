
variable "domain_name" {
  type        = string
  description = "The name of the domain."
}

variable "comment" {
  type        = string
  description = "Any comments you want to include about the hosted zone."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to associate with."
  default     = null
}

variable "enable_query_logs" {
  type        = bool
  description = "Enable query logging to CloudWatch Logs."
  default     = true
}

variable "cloudwatch_logs_retention_days" {
  type        = number
  description = "The number of days log events are kept in CloudWatch Logs."
  default     = 30
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}
