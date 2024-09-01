data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  # Construct the configuration of ECR repositories that combine the raw user input with the configured defaults.
  repositories_with_defaults = {
    for repo_name, user_config in var.repositories :
    repo_name => {
      external_account_ids_with_read_access   = lookup(user_config, "external_account_ids_with_read_access", var.default_external_account_ids_with_read_access)
      external_account_ids_with_write_access  = lookup(user_config, "external_account_ids_with_write_access", var.default_external_account_ids_with_write_access)
      external_account_ids_with_lambda_access = lookup(user_config, "external_account_ids_with_lambda_access", var.default_external_account_ids_with_lambda_access)
      enable_automatic_image_scanning         = lookup(user_config, "enable_automatic_image_scanning", var.default_automatic_image_scanning)
      encryption_config                       = lookup(user_config, "encryption_config", var.default_encryption_config)
      image_tag_mutability                    = lookup(user_config, "image_tag_mutability", var.default_image_tag_mutability)
      lifecycle_policy_rules                  = lookup(user_config, "lifecycle_policy_rules", var.default_lifecycle_policy_rules)
      tags = merge(
        lookup(user_config, "tags", {}),
        var.tags_all,
      )
    }
  }

  repositories_with_lifecycle_rules = {
    for repo_name, repo in local.repositories_with_defaults :
    repo_name => repo if length(repo.lifecycle_policy_rules) > 0
  }
  repositories_with_external_access = {
    for repo_name, repo in local.repositories_with_defaults :
    repo_name => repo
    if(
      length(repo.external_account_ids_with_read_access) > 0
      || length(repo.external_account_ids_with_write_access) > 0
      || length(repo.external_account_ids_with_lambda_access) > 0
    )
  }

  # The list of IAM policy actions for write access
  iam_write_access_policies = [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:GetRepositoryPolicy",
    "ecr:DescribeRepositories",
    "ecr:ListImages",
    "ecr:DescribeImages",
    "ecr:BatchGetImage",
    "ecr:InitiateLayerUpload",
    "ecr:UploadLayerPart",
    "ecr:CompleteLayerUpload",
    "ecr:PutImage",
  ]

  # The list of IAM policy actions for read access
  iam_read_access_policies = [
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "ecr:BatchCheckLayerAvailability",
    "ecr:ListImages",
  ]
}

resource "aws_ecr_repository" "repos" {
  for_each = local.repositories_with_defaults

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability
  tags                 = each.value.tags

  image_scanning_configuration {
    scan_on_push = each.value.enable_automatic_image_scanning
  }

  dynamic "encryption_configuration" {
    for_each = each.value.encryption_config != null ? ["once"] : []
    content {
      encryption_type = each.value.encryption_config.encryption_type
      kms_key         = each.value.encryption_config.kms_key
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = local.repositories_with_lifecycle_rules
  repository = aws_ecr_repository.repos[each.key].name
  policy     = jsonencode(each.value.lifecycle_policy_rules)
}

resource "aws_ecr_replication_configuration" "this" {
  count = length(var.replication_regions) > 0 ? 1 : 0
  replication_configuration {
    rule {

      dynamic "destination" {
        for_each = var.replication_regions
        content {
          region      = destination.value
          registry_id = data.aws_caller_identity.current.account_id
        }
      }
    }
  }
}
