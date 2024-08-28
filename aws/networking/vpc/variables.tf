variable "name" {
  description = "The name of the VPC to create"
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block to assign to the VPC"
  type        = string
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway for the VPC"
  type        = bool
  default     = true
}

variable "enable_default_security_group" {
  description = "Whether to create the default security group for the VPC.  If false, the default security group will be created but not managed by Terraform."
  type        = bool
  default     = false
}

variable "apply_default_nacl_rules" {
  description = "Whether to apply default NACL rules to the VPC"
  type        = bool
  default     = true
}

variable "default_nacl_ingress_rules" {
  description = "Whether to apply default NACL rules to the VPC.  This blocks inbound RDP and SSH traffic from the internet, and allows all other traffic."
  type        = any
  default = {
    DenyRDPIPv4 = {
      from_port  = 3389
      to_port    = 3389
      action     = "deny"
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
      rule_no    = 10
    }
    DenyRDPIPv6 = {
      from_port  = 3389
      to_port    = 3389
      action     = "deny"
      protocol   = "-1"
      cidr_block = "::/0"
      rule_no    = 11
    }
    DenySSHIPv4 = {
      from_port  = 22
      to_port    = 22
      action     = "deny"
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
      rule_no    = 12
    }
    DenySSHIPv6 = {
      from_port  = 22
      to_port    = 22
      action     = "deny"
      protocol   = "-1"
      cidr_block = "::/0"
      rule_no    = 13
    }
    AllowAllIPv4 = {
      from_port  = 0
      to_port    = 0
      action     = "allow"
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
      rule_no    = 100
    }
    AllowAllIPv6 = {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
      rule_no         = 101
    }
  }
}

variable "default_nacl_egress_rules" {
  description = "Whether to apply default NACL rules to the VPC.  This allows all outbound traffic."
  type        = any
  default = {
    AllowAllIPv4 = {
      from_port  = 0
      to_port    = 0
      action     = "allow"
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
      rule_no    = 100
    }
    AllowAllIPv6 = {
      from_port       = 0
      to_port         = 0
      action          = "allow"
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
      rule_no         = 101
    }
  }
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create"
  type        = number
  default     = 2
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets in each AZ"
  type        = map(string)
  default     = {}
}

variable "public_subnet_bits" {
  description = "Number of bits to allocate for the subnet (e.g. 8 would create subnets of size /24)"
  type        = number
  default     = 5
}

variable "public_subnet_ipv6_cidr_blocks" {
  description = "CIDR blocks for public subnets in each AZ"
  type        = map(string)
  default     = {}
}

variable "ipv6_subnet_bits" {
  description = "Number of bits to allocate for the subnet (e.g. 8 would create subnets of size /56)"
  type        = number
  default     = 8
  validation {
    condition     = var.ipv6_subnet_bits == null ? true : (var.ipv6_subnet_bits >= 0 && var.ipv6_subnet_bits <= 8)
    error_message = "The variable ipv6_subnet_bits can either be set to null or a value between 0 and 8."
  }
}

variable "private_app_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets in each AZ"
  type        = map(string)
  default     = {}
}

variable "private_subnet_bits" {
  description = "Number of bits to allocate for the subnet"
  type        = number
  default     = 5
}

variable "private_spacing" {
  type        = number
  description = "Number of subnets to space out the private subnets"
  default     = 0
}

variable "private_persistence_subnet_cidr_blocks" {
  description = "CIDR blocks for private persistence subnets in each AZ"
  default     = {}
}

variable "private_persistence_subnet_bits" {
  type        = number
  description = "Number of bits to allocate for the subnet"
  default     = 5
}

variable "private_persistence_spacing" {
  type        = number
  description = "Number of subnets to space out the private persistence subnets"
  default     = 0
}

variable "create_vpc_endpoints" {
  description = "Create VPC endpoints for S3 and DynamoDB at no additional cost"
  type        = bool
  default     = true
}

variable "tags_all" {
  description = "A map of tags to add to all resources created by this module"
  type        = map(string)
  default     = {}
}
