variable "name" {
  description = "The name of the VPC to create"
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block to assign to the VPC"
  type        = string
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create"
  type        = number
  default     = 2
}

variable "subnet_spacing" {
  description = "The amount of spacing between the different subnet types"
  type        = number
  default     = 10
}

variable "private_app_subnet_spacing" {
  description = "The amount of spacing between private app subnets."
  type        = number
  default     = null
}

variable "private_persistence_subnet_spacing" {
  description = "The amount of spacing between the private persistence subnets."
  type        = number
  default     = null
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

variable "private_app_subnet_bits" {
  description = "Number of bits to allocate for the subnet"
  type        = number
  default     = 5
}

variable "private_spacing" {
  type        = number
  description = "Number of subnets to space out the private subnets"
  default     = 0
}

variable "private_app_subnet_ipv6_cidr_blocks" {
  description = "CIDR blocks for private subnets in each AZ"
  type        = map(string)
  default     = {}
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

variable "private_persistence_subnet_ipv6_cidr_blocks" {
  description = "CIDR blocks for private persistence subnets in each AZ"
  type        = map(string)
  default     = {}
}


variable "allow_private_persistence_internet_access" {
  description = "Whether to allow private persistence subnets to access the internet"
  type        = bool
  default     = false
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
