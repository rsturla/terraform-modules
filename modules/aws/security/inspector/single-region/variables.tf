variable "create_resources" {
  description = "Whether to create resources or not"
  type        = bool
  default     = false
}

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

variable "auto_enable_member_accounts" {
  description = "Automatically enable AWS Inspector on all member accounts."
  type        = bool
  default     = false
}

variable "enabled_account_ids" {
  description = "A list of account IDs to enable AWS Inspector on."
  type        = list(string)
  default     = []
}

variable "resource_types" {
  description = "A list of resource types to enable AWS Inspector on."
  type        = list(string)
  default     = ["ECR", "EC2", "LAMBDA"]
}
