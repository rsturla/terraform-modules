variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The IDs of the public subnets"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets"
}

variable "private_persistence_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private persistence subnets"
}

variable "public_subnet_nacl_ingress_rules" {
  description = "A map of ingress rules to apply to the public subnets"
  type        = map(any)
  default     = {}
}

variable "public_subnet_nacl_egress_rules" {
  description = "A map of egress rules to apply to the public subnets"
  type        = map(any)
  default     = {}
}

variable "private_subnet_nacl_ingress_rules" {
  description = "A map of ingress rules to apply to the private subnets"
  type        = map(any)
  default     = {}
}

variable "private_subnet_nacl_egress_rules" {
  description = "A map of egress rules to apply to the private subnets"
  type        = map(any)
  default     = {}
}

variable "private_persistence_subnet_nacl_ingress_rules" {
  description = "A map of ingress rules to apply to the private persistence subnets"
  type        = map(any)
  default     = {}
}

variable "private_persistence_subnet_nacl_egress_rules" {
  description = "A map of egress rules to apply to the private persistence subnets"
  type        = map(any)
  default     = {}
}

variable "apply_default_nacl_rules" {
  description = "Whether to apply default NACL rules to the VPC.  This blocks inbound RDP and SSH traffic from the internet, and allows all other traffic."
  type        = bool
  default     = true
}

variable "tags_all" {
  type    = map(string)
  default = {}
}

variable "allow_private_persistence_internet_access" {
  description = "Whether to allow internet access from the private persistence subnets"
  type        = bool
  default     = false
}
