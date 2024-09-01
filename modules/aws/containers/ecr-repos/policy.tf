resource "aws_ecr_repository_policy" "external_account_access" {
  for_each   = local.repositories_with_external_access
  repository = aws_ecr_repository.repos[each.key].name
  policy     = data.aws_iam_policy_document.external_account_access[each.key].json
}

data "aws_iam_policy_document" "external_account_access" {
  for_each = local.repositories_with_external_access

  dynamic "statement" {
    for_each = length(each.value.external_account_ids_with_read_access) > 0 ? ["noop"] : []

    content {
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = formatlist("arn:${data.aws_partition.current.partition}:iam::%s:root", each.value.external_account_ids_with_read_access)
      }

      actions = local.iam_read_access_policies
    }
  }

  dynamic "statement" {
    for_each = length(each.value.external_account_ids_with_write_access) > 0 ? ["noop"] : []

    content {
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = formatlist("arn:${data.aws_partition.current.partition}:iam::%s:root", each.value.external_account_ids_with_write_access)
      }

      actions = local.iam_write_access_policies
    }
  }

  dynamic "statement" {
    for_each = each.value.external_account_ids_with_lambda_access

    content {
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      condition {
        test     = "StringLike"
        variable = "aws:sourceARN"

        # Allow lambda function access in any of the regions that the ECR repo is created for each account.
        values = [
          for region in concat([data.aws_region.current.name], var.replication_regions) :
          "arn:${data.aws_partition.current.partition}:lambda:${region}:${statement.value}:function:*"
        ]
      }

      actions = local.iam_read_access_policies
    }
  }
}
