variable "vpc_id" {
  description = "The ID of the VPC that you want to associate with the firewall configuration."
  type        = string
}

variable "firewall_fail_open" {
  description = "Determines how Route 53 Resolver handles queries during failures, for example when all traffic that is sent to DNS Firewall fails to receive a reply."
  default     = "DISABLED"
  type        = string
}

variable "managed_domain_lists" {
  description = "A list of the domain lists that you want to use for DNS filtering. To retrieve a list of the domain lists that are associated with the account, use ListFirewallDomainLists."
  type        = list(string)
  default = [
    "AWSManagedDomainsMalwareDomainList",
    "AWSManagedDomainsBotnetCommandandControl",
    "AWSManagedDomainsAggregateThreatList",
  ]
}

variable "managed_domain_list_action" {
  description = "The action that DNS Firewall should take on a DNS query when it matches one of the domains in the rule's domain list."
  type        = string
  default     = "BLOCK"
  validation {
    condition     = can(regex("^(ALERT|BLOCK)$", var.managed_domain_list_action))
    error_message = "The action must be either ALERT or BLOCK."
  }
}

variable "tags_all" {
  description = "A map of tags to assign to all resources created by the module."
  type        = map(string)
  default     = {}
}
