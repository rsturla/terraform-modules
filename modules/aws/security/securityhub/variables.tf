variable "opt_in_regions" {
  type        = list(string)
  default     = []
  description = "List of regions to opt in to Security Hub"
}

variable "enabled_standards" {
  type        = list(string)
  default     = []
  description = "List of standards to enable"
}

variable "external_member_accounts" {
  type = map(object({
    account_id = string
    email      = string
  }))
  default     = {}
  description = "Map of external member accounts to invite to Security Hub"
}

variable "delegated_administrator_account_id" {
  type        = string
  description = "The account ID of the delegated administrator for Security Hub"
  default     = null
}

variable "aggregate_region" {
  type        = string
  description = "The region to aggregate findings in"
  default     = null
}
