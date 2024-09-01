variable "plans" {
  type = map(object({
    custom_iam_role_arn = optional(string, null)
    rules = map(object({
      target_vault_name        = optional(string, "Default")
      schedule                 = optional(string, null)
      enable_continuous_backup = optional(bool, null)
      start_window             = optional(number, null)
      completion_window        = optional(number, null)
      lifecycle = optional(object({
        cold_storage_after = optional(number, null)
        delete_after       = optional(number, null)
      }), null)
      recovery_point_tags = optional(map(string), null)
      copy_action = optional(object({
        destination_vault_arn = optional(string, null)
        lifecycle = optional(object({
          cold_storage_after = optional(number, null)
          delete_after       = optional(number, null)
        }), null)
      }), null)
    }))
    condition = optional(object({
      string_equals     = optional(map(string), {})
      string_not_equals = optional(map(string), {})
      string_like       = optional(map(string), {})
      string_not_like   = optional(map(string), {})
    }), {})
    resources = optional(list(string), null)
  }))
}

variable "backup_service_role_name" {
  type        = string
  description = "The name to use for the backup service role that is created and attached to backup plans."
  default     = "backup-service-role"
}

variable "tags_all" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
