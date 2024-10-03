variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "assume_role_statements" {
  description = "The IAM trust policy for the role"
  type        = any
  default     = {}
}

variable "policy_arns" {
  description = "The ARNs of the IAM policies to attach to the role"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "The IAM policy to attach to the role"
  type        = any
  default     = {}
}
