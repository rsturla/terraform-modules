variable "name" {
  description = "The name of the stackset"
  type        = string
}

variable "description" {
  description = "The description of the stackset"
  type        = string
  default     = null
}

variable "template" {
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

variable "auto_deployment_enabled" {
  description = "Whether to automatically deploy to new accounts or organization units"
  type        = bool
  default     = false
}
