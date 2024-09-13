variable "name" {
  type        = string
  description = "The name of the service"
}

variable "monitoring_interval" {
  type        = number
  default     = 30
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0."
}

variable "database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created."
  default     = null
}

variable "engine" {
  type        = string
  description = "The database engine to use"
}

variable "engine_version" {
  type        = string
  description = "The engine version to use.  For automatic upgrades to work properly, do not specify the patch version."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  default     = true
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Indicates that major engine upgrades will be applied automatically to the DB instance during the maintenance window."
  default     = true
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes"
  default     = null
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance."
  default     = null
}

variable "encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted."
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true.  If not specified, the default encryption key for the account will be used."
  default     = null
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
  default     = true
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the RDS instance should be ran in multiple availability zones"
  default     = true
}

variable "port" {
  type        = number
  description = "The port on which the DB accepts connections"
  default     = null
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "A list of additional security group IDs to attach to the RDS instances"
  default     = []
}

variable "auth_configuration" {
  type = object({
    username                            = string
    initial_password                    = string
    iam_database_authentication_enabled = optional(bool, false)
  })
  description = "The authentication configuration for the RDS instance"
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "sun:03:00-sun:04:00"
  validation {
    condition     = can(regex("^[a-z]{3}:[0-9]{2}:[0-9]{2}-[a-z]{3}:[0-9]{2}:[0-9]{2}$", var.maintenance_window))
    error_message = "The maintenance window must be in the format 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  }
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "A list of log types to export to CloudWatch. If omitted, no logs will be exported."
  default     = []
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Specifies whether Performance Insights is enabled."
  default     = true
}

variable "performance_insights_retention_period" {
  type        = number
  description = "The amount of time in days to retain Performance Insights data. Valid values are 7 or 731 (2 years)."
  default     = 7
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to assign to the resource"
  default     = {}
}

variable "read_replicas" {
  type = map(object({
    instance_class                      = string
    deletion_protection                 = optional(bool, null)
    multi_az                            = optional(bool, false)
    automated_snapshot_retention_period = optional(number, 0)
    parameters = optional(map(object({
      value        = any
      apply_method = optional(string, null)
    })), {})
  }))
  description = "A map of read replicas to create for the RDS instance. The key is the identifier of the read replica."
  default     = {}
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs that the RDS instance should be created in."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID that the RDS instance should be created in."
}

variable "parameters" {
  type = map(object({
    value        = any
    apply_method = optional(string, null)
  }))
  description = "A map of parameters to apply to the RDS instance. The key is the name of the parameter, and the value is the object which consists of value and apply_method."
  default     = {}
}

variable "alarms_enabled" {
  type        = bool
  description = "Whether to create CloudWatch alarms for the RDS instance"
  default     = true
}

variable "alarm_event_categories" {
  type        = list(string)
  description = "The event categories for the RDS alarms.  To disable the event categories, set this to an empty list or null."
  default     = ["availability", "configuration change", "deletion", "failover", "failure", "low storage", "notification", "maintenance", "recovery", "restoration"]
}

variable "alarm_thresholds" {
  type = object({
    burst_balance_pct      = optional(number, 80)
    cpu_utilization_pct    = optional(number, 80)
    cpu_credit_balance     = optional(number, 0)
    disk_queue_depth       = optional(number, 20)
    free_storage_space_pct = optional(number, 20)
    freeable_memory        = optional(number, null)
    replica_lag            = optional(number, 90)
  })
  description = "The thresholds for the RDS alarms.  To disable individual alarms, set the value to null."
  default     = {}
}

variable "dns_zone_name" {
  type        = string
  description = "The DNS zone name for the RDS instance.  If omitted, no DNS record will be created."
  default     = null
}

variable "dns_record_name" {
  type        = string
  description = "The DNS record name for the RDS instance.  If omitted, no DNS record will be created."
  default     = null
}

variable "options" {
  type        = map(string)
  description = "The MySQL options for the RDS instance.  If omitted, no options will be applied."
  default     = {}
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier."
  default     = false
}

variable "allow_ingress_from_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks to allow ingress from"
  default     = []
}

variable "allow_ingress_from_security_groups" {
  type        = list(string)
  description = "A list of security group IDs to allow ingress from"
  default     = []
}

variable "automated_snapshot_retention_period" {
  type        = number
  description = "The number of days to retain automated snapshots"
  default     = 14
}

variable "snapshot_identifier" {
  type        = string
  description = "The snapshot to create the DB from"
  default     = null
}

variable "allow_egress_to_cidrs" {
  type        = list(string)
  description = "Determines which CIDR ranges the instances can access"
  default     = []
}

variable "allow_egress_to_managed_prefix_lists" {
  type        = list(string)
  description = "Determines which managed prefix lists the instances can access"
  default     = []
}

variable "allowed_buckets_to_import" {
  type        = list(string)
  description = "A list of S3 buckets that the RDS instance should be allowed to import data from"
  default     = []
}

variable "allowed_buckets_to_export" {
  type        = list(string)
  description = "A list of S3 buckets that the RDS instance should be allowed to export data to"
  default     = []
}
