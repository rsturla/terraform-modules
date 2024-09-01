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

variable "nat_instance_count" {
  type        = number
  description = "The number of NAT Instances to create.  If defined, will not create a NAT Gateway"
  default     = 0
}

variable "nat_instance_type" {
  description = "The instance type to use for the NAT Instance"
  type        = string
  default     = "t3.nano"
}

variable "nat_instance_ami_id" {
  description = "The AMI ID to use for the NAT Instance"
  type        = string
  default     = null
}

variable "nat_instance_ami_name_pattern" {
  description = "The pattern to use for selecting the AMI"
  type        = string
  default     = "aws/images/networking/vpc/nat-instance-*"
}

variable "nat_instance_ami_owner" {
  description = "The owner of the AMI"
  type        = string
  default     = "self"
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

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "REJECT"
}

variable "flow_log_cloudwatch_log_retention_in_days" {
  description = "The number of days to retain log events in CloudWatch Logs."
  type        = number
  default     = 14
}

variable "tags_all" {
  description = "A map of tags to add to all resources created by this module"
  type        = map(string)
  default     = {}
}
