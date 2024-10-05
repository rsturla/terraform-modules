variable "create_organization" {
  description = "Whether to create an AWS organization"
  type        = bool
  default     = true
}

variable "organizations_aws_service_access_principals" {
  description = "The service principals for which to enable access to the organization"
  type        = list(string)
  default     = []
}

variable "organizations_enabled_policy_types" {
  description = "The policy types to enable in the organization"
  type        = list(string)
  default     = []
}

variable "organizations_delegated_administrators" {
  description = "The accounts to designate as delegated administrators in the organization"
  type        = map(string)
  default     = {}
}

variable "organizations_feature_set" {
  description = "The feature set to enable in the organization"
  type        = string
  default     = "ALL"
}

variable "child_accounts" {
  description = "A map of child accounts to create"
  type = map(object({
    email                      = string
    close_on_deletion          = optional(bool, false)
    iam_user_access_to_billing = optional(bool, true)
    parent_id                  = optional(string, null)
    role_name                  = optional(string, null)
    tags                       = optional(map(string), {})
  }))
  default = {}
}

variable "default_iam_user_access_to_billing" {
  description = "Whether to allow IAM users to access billing information for the account"
  type        = bool
  default     = true
}

variable "default_role_name" {
  description = "The name of the role to create for the account"
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "tags_all" {
  description = "A map of tags to assign to the account"
  type        = map(string)
  default     = {}
}
