variable "create_resources" {
  type = bool
}

variable "standards" {
  type = list(string)
}

variable "external_member_accounts" {
  type = map(object({
    account_id = string
    email      = string
  }))
  default = {}
}


variable "enable_default_standards" {
  type        = bool
  description = "Whether to enable the CIS AWS Foundations Benchmark and AWS Foundational Security Best Practices standards. Defaults to false so these can be defined alongside other standards."
  default     = false
}

variable "control_finding_generator" {
  type        = string
  default     = null
  description = <<-EOT
    Updates whether the calling account has consolidated control
    findings turned on. If the value for this field is set to SECURITY_CONTROL,
    Security Hub generates a single finding for a control check even when the
    check applies to multiple enabled standards. If the value for this field is
    set to STANDARD_CONTROL, Security Hub generates separate findings for a
    control check when the check applies to multiple enabled standards. For
    accounts that are part of an organization, this value can only be updated
    in the administrator account.
    EOT
  validation {
    condition     = var.control_finding_generator == null || var.control_finding_generator == "SECURITY_CONTROL" || var.control_finding_generator == "STANDARD_CONTROL"
    error_message = "control_finding_generator must be either null, 'SECURITY_CONTROL' or 'STANDARD_CONTROL'"
  }
}

variable "auto_enable_controls" {
  type    = bool
  default = true
}

variable "delegated_administrator_account_id" {
  type        = string
  description = "The account ID of the delegated administrator for Security Hub"
  default     = null
}

variable "is_aggregate_region" {
  type        = bool
  description = "Whether this region is an aggregate region"
  default     = false
}
