variable "vaults" {
  description = "A map of backup vaults to create"
  type        = any
}

variable "create_kms_key" {
  type        = bool
  description = "Whether to create and use Customer Managed KMS key for the vault"
  default     = false
}

variable "kms_key_alias" {
  type        = string
  description = "The alias to use for the KMS key"
  default     = null
  validation {
    error_message = "Alias must begin with 'alias/' if provided"
    condition     = var.create_kms_key && !can(regex("^alias/", var.kms_key_alias)) ? false : true
  }
}

variable "backup_source_accounts" {
  type        = list(string)
  description = "A list of AWS account IDs to allow access to the vault"
  default     = []
}

variable "default_max_retention_days" {
  type        = number
  description = "The ceiling of retention days that can be configured via a backup plan for the given vault"
  default     = 180
}

variable "default_min_retention_days" {
  type        = number
  description = "The minimum number of retention days that can be configured via a backup plan for the given vault"
  default     = 7
}

variable "default_changeable_for_days" {
  type        = number
  description = "The cooling-off-period during which you can still delete the lock placed on your vault. The AWS default is 3 days. After this period expires, YOUR LOCK CANNOT BE DELETED"
  default     = 3
}

variable "tags_all" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
