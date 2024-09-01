data "aws_caller_identity" "current" {}

resource "aws_backup_vault" "this" {
  for_each    = local.vaults
  name        = each.key
  kms_key_arn = var.create_kms_key && each.value.kms_key_arn == null ? aws_kms_key.backup[0].arn : each.value.kms_key_arn

  tags = merge(
    var.tags_all,
    each.value.tags,
  )
}

data "aws_iam_policy_document" "vault_policy" {
  for_each = local.vaults_with_policies_attached

  dynamic "statement" {
    for_each = each.value.backup_policy

    content {
      sid       = statement.key
      effect    = lookup(statement.value, "effect", "Allow")
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = lookup(statement.value, "principal", null) != null ? ["once"] : []

        content {
          type        = statement.value.principal.type
          identifiers = statement.value.principal.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_backup_vault_policy" "vault_policy" {
  for_each          = local.vaults_with_policies_attached
  backup_vault_name = each.key
  policy            = data.aws_iam_policy_document.vault_policy[each.key].json
}

resource "aws_backup_vault_lock_configuration" "lock" {
  for_each = {
    for vault_name, conf in local.vaults :
    vault_name => conf if conf.vault_lock_enabled
  }

  backup_vault_name   = each.key
  changeable_for_days = each.value.changeable_for_days
  min_retention_days  = each.value.min_retention_days
  max_retention_days  = each.value.max_retention_days
}

locals {
  vaults = { for vault_name, conf in var.vaults :
    vault_name => {
      kms_key_arn          = lookup(conf, "kms_key_arn", null),
      vault_lock_enabled   = lookup(conf, "vault_lock_enabled", true),
      changeable_for_days  = lookup(conf, "changeable_for_days", var.default_changeable_for_days),
      max_retention_days   = lookup(conf, "max_retention_days", var.default_max_retention_days),
      min_retention_days   = lookup(conf, "min_retention_days", var.default_min_retention_days)
      enable_notifications = lookup(conf, "enable_notifications", false),
      events_to_listen_for = lookup(conf, "events_to_listen_for", local.all_backup_events)
      attach_policy        = lookup(conf, "attach_policy", false)
      backup_policy        = lookup(conf, "backup_policy", null)
      tags                 = lookup(conf, "tags", {}),
    }
  }

  vaults_with_notifications = { for vault_name, conf in local.vaults : vault_name => conf if conf.enable_notifications }

  vaults_with_policies_attached = {
    for vault_name, conf in local.vaults :
    vault_name => conf if conf.backup_policy != null
  }

  # If operator does not pass in a specific list of AWS Backup events to listen for, default to listening for all events
  all_backup_events = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_COMPLETED",
    "COPY_JOB_STARTED",
    "COPY_JOB_SUCCESSFUL",
    "COPY_JOB_FAILED",
    "RESTORE_JOB_STARTED",
    "RESTORE_JOB_COMPLETED",
    "RECOVERY_POINT_MODIFIED"
  ]
}
