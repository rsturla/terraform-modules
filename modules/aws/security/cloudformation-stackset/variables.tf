variable "name" {
  description = "The name of the stackset"
  type        = string
}

variable "description" {
  description = "The description of the stackset"
  type        = string
  default     = null
}

variable "capabilities" {
  description = "A list of capabilities to pass to the stackset"
  type        = list(string)
  default     = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
}

variable "template_body" {
  description = "The template body"
  type        = string
  default     = null
}

variable "template_url" {
  description = "The URL of the template"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of parameters to pass to the stackset"
  type        = map(string)
  default     = {}
}

variable "tags_all" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "target_accounts" {
  description = "A list of account IDs to target"
  type        = list(string)
  default     = []
}

variable "target_org_units" {
  description = "A list of organization unit IDs to target"
  type        = list(string)
  default     = []
}
