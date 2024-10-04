variable "name" {
  type        = string
  description = "Name of the Cloudformation Stack"
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "template_body" {
  type        = string
  description = "Structure containing the template body"
  default     = null
}

variable "template_url" {
  type        = string
  description = "Location of file containing the template body"
  default     = null
}

variable "capabilities" {
  type        = list(string)
  description = "A list of capabilities. Valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, or CAPABILITY_AUTO_EXPAND"
  default     = null
}

variable "disable_rollback" {
  type        = bool
  description = "Determines whether to rollback the stack if stack creation failed. Conflicts with on_failure"
  default     = null
}

variable "notification_arns" {
  type        = list(string)
  description = "A list of SNS topic ARNs to publish stack related events"
  default     = []
}

variable "on_failure" {
  type        = string
  description = "Action to be taken if stack creation fails. This must be one of: DO_NOTHING, ROLLBACK, or DELETE. Conflicts with disable_rollback"
  default     = null
}

variable "parameters" {
  type        = map(string)
  description = "A map of parameters to pass to the stack"
  default     = {}
}

variable "cloudformation_stack_policy_body" {
  type        = any
  description = "Structure containing the stack policy body. Conflicts with policy_url"
  default     = null
}

variable "cloudformation_stack_policy_url" {
  type        = string
  description = "Location of a file containing the stack policy body. Conflicts w/ policy_body"
  default     = null
}

variable "timeout_in_minutes" {
  type        = number
  description = "The amount of time that can pass before the stack status becomes CREATE_FAILED"
  default     = null
}

variable "assume_policy_statements" {
  type        = any
  description = "The IAM policy to apply to this cloudformation stack."
  default     = {}
}
