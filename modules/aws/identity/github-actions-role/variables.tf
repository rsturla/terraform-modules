variable "create_openid_connect_provider" {
  description = "Whether to create the OpenID Connect provider for GitHub Actions"
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "repository" {
  description = "The GitHub repository in the format 'owner/repo'"
  type        = string
}

variable "git_pattern" {
  description = "The GitHub pattern to match.  This controls which branches, environments or tags can assume the role"
  type        = string
}

variable "policy_arns" {
  description = "The ARNs of the IAM policies to attach to the role"
  type        = list(string)
  default     = []
}
