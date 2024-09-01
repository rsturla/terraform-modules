output "ecr_repo_arns" {
  description = "A map of repository name to its ECR ARN."
  value       = module.ecr_repos.ecr_repo_arns
}

output "ecr_repo_urls" {
  description = "A map of repository name to its URL."
  value       = module.ecr_repos.ecr_repo_urls
}

output "ecr_read_policy_actions" {
  description = "A list of IAM policy actions necessary for ECR read access."
  value       = module.ecr_repos.ecr_read_policy_actions
}

output "ecr_write_policy_actions" {
  description = "A list of IAM policy actions necessary for ECR write access."
  value       = module.ecr_repos.ecr_write_policy_actions
}
