module "vault" {
  source = "../../../../modules/aws/data-storage/backup-vaults"

  create_kms_key = true
  kms_key_alias  = "alias/backup"

  vaults = {
    "example-vault" = {}
  }
}

module "backup_plan" {
  source = "../../../../modules/aws/data-storage/backup-plan"

  backup_service_role_name = "example-backup-service-role"

  plans = {
    "ec2-default-backup-plan" = {
      rules = {
        daily = {
          target_vault_name = "Default"
          schedule          = "cron(0 12 * * ? *)" # Daily at 12:00 UTC
        }
        weekly = {
          target_vault_name = "Default"
          schedule          = "cron(0 12 ? * 1 *)" # Weekly on Monday at 12:00 UTC
        }
      }
      condition = {
        string_equals = {
          "aws:ResourceTag/SampleTag" = "example"
        }
      }
    }
  }
}
