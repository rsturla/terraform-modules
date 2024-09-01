variable "repositories" {
  description = "A map of repo names to configurations for that repository."
  type        = any
}

variable "default_external_account_ids_with_read_access" {
  description = "The default list of AWS account IDs for external AWS accounts that should be able to pull images from these ECR repos. Can be overridden on a per repo basis by the external_account_ids_with_read_access property in the repositories map."
  type        = list(string)
  default     = []
}

variable "default_external_account_ids_with_write_access" {
  description = "The default list of AWS account IDs for external AWS accounts that should be able to pull and push images to these ECR repos. Can be overridden on a per repo basis by the external_account_ids_with_write_access property in the repositories map."
  type        = list(string)
  default     = []
}

variable "default_external_account_ids_with_lambda_access" {
  description = "The default list of AWS account IDs for external AWS accounts that should be able to create Lambda functions based on container images in these ECR repos. Can be overridden on a per repo basis by the external_account_ids_with_lambda_access property in the repositories map."
  type        = list(string)
  default     = []
}

variable "default_automatic_image_scanning" {
  description = "Whether or not to enable image scanning on all the repos. Can be overridden on a per repo basis by the enable_automatic_image_scanning property in the repositories map."
  type        = bool
  default     = true
}

variable "default_encryption_config" {
  description = "The default encryption configuration to apply to the created ECR repository. When null, the images in the ECR repo will not be encrypted at rest. Can be overridden on a per repo basis by the encryption_config property in the repositories map."
  type = object({
    encryption_type = string
    kms_key         = string
  })
  default = {
    encryption_type = "AES256"
    kms_key         = null
  }
}

variable "default_image_tag_mutability" {
  description = "The tag mutability setting for all the repos. Must be one of: MUTABLE or IMMUTABLE. Can be overridden on a per repo basis by the image_tag_mutability property in the repositories map."
  type        = string
  default     = "MUTABLE"
}

variable "tags_all" {
  description = "A map of tags (where the key and value correspond to tag keys and values) that should be assigned to all ECR repositories."
  type        = map(string)
  default     = {}
}

variable "default_lifecycle_policy_rules" {
  description = "Add lifecycle policy to ECR repo."
  type        = any
  default     = []
}

variable "replication_regions" {
  description = "List of regions (e.g., us-east-1) to replicate the ECR repository to."
  type        = list(string)
  default     = []
}
