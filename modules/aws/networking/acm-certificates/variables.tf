variable "zone_id" {
  type        = string
  description = "The zone id of the hosted zone to create the validation records in.  If not provided, the certificate will not be validated."
  default     = null
}

variable "certificates" {
  type = map(object({
    subject_alternative_names  = list(string)
    create_verification_record = optional(bool, true)
  }))
  description = "A list of certificates to create."
}

variable "tags_all" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}
