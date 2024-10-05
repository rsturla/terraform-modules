variable "sso_groups" {
  description = "Names of the groups you wish to create in IAM Identity Center."
  type = map(string)
  default = {}
}

variable "permission_sets" {
  description = "Permission Sets that you wish to create in IAM Identity Center. This variable is a map of maps containing Permission Set names as keys."
  type        = any
  default     = {}
}

variable "account_assignments" {
  description = "List of maps containing mapping between user/group, permission set and assigned accounts list."
  type = map(object({
    principal_name  = string
    principal_type  = optional(string, "GROUP")
    permission_sets = list(string)
    account_ids     = list(string)
  }))
  default = {}
}

variable "tags_all" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
