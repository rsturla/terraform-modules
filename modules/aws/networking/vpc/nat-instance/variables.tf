variable "name_prefix" {
  type        = string
  description = "A prefix to apply to all resources created by this module"
}

variable "availability_zone" {
  type        = string
  description = "The Availability Zone to launch the NAT Instance in"
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "The subnet id to create the NAT gateway in."
}

variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the NAT Instance."
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the NAT Instance."
}

variable "tags_all" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}
