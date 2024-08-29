variable "is_organization_management_account" {
  type        = bool
  description = "Whether or not this account is the organization management account."
  default     = false
}

variable "delegated_administrator_account_id" {
  type        = string
  description = "The delegated administrator to maintain the organization AWS Inspector configuration.  Only set this in the root (management) account."
  default     = null
}

variable "auto_enable_member_accounts" {
  type        = bool
  description = "Automatically enable AWS Inspector on all member accounts."
  default     = false
}

variable "enabled_account_ids" {
  type        = list(string)
  description = "A list of account IDs to enable AWS Inspector on."
  default     = []
}

variable "resource_types" {
  type        = list(string)
  description = "A list of resource types to enable AWS Inspector on."
  default     = ["ECR", "EC2", "LAMBDA"]
}

variable "export_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to export Inspector findings to.  If not set, no bucket will be created."
  default     = null
}


variable "opt_in_regions" {
  type        = list(string)
  default     = []
  description = "List of regions to opt in to AWS Inspector.  If not set, current region will be opted in"
}
