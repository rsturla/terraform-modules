variable "budgets" {
  description = "A map of budgets to create"
  type = map(object({
    budget_type       = optional(string, "COST")
    limit_amount      = number
    limit_unit        = optional(string, "USD")
    time_period_start = optional(string, null)
    time_period_end   = optional(string, null)
    time_unit         = optional(string, "MONTHLY")
    cost_types = optional(object({
      include_credit             = optional(bool, false)
      include_discount           = optional(bool, false)
      include_other_subscription = optional(bool, false)
      include_recurring          = optional(bool, false)
      include_refund             = optional(bool, false)
      include_subscription       = optional(bool, false)
      include_support            = optional(bool, false)
      include_tax                = optional(bool, false)
      include_upfront            = optional(bool, false)
      use_blended                = optional(bool, false)
      }), {
      include_credit             = false
      include_discount           = false
      include_other_subscription = false
      include_recurring          = false
      include_refund             = false
      include_subscription       = true
      include_support            = false
      include_tax                = false
      include_upfront            = false
      use_blended                = false
    })
    cost_filter = list(object({
      name   = string
      values = list(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to create for budget notifications"
  type        = string
  default     = "budget-notifications"
}

variable "notifications" {
  description = "A list of notifications to create for budgets"
  type = list(object({
    comparison_operator        = optional(string, "GREATER_THAN")
    notification_type          = optional(string, "ACTUAL")
    threshold                  = optional(number, 100)
    threshold_type             = optional(string, "PERCENTAGE")
    subscriber_email_addresses = optional(list(string), [])
    subscriber_sns_topic_arns  = optional(list(string), [])
  }))
  default = []
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to assign to all resources"
  default     = {}
}
