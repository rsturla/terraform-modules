locals {
  default_port = 5432
  port         = var.port == null ? local.default_port : var.port

  default_log_exports = ["postgresql", "upgrade"]
  log_exports         = length(var.enabled_cloudwatch_logs_exports) == 0 ? local.default_log_exports : var.enabled_cloudwatch_logs_exports

  # Generate the parameter group family based on the engine version
  engine_major_version   = split(".", var.engine_version)[0]
  parameter_group_family = "postgres${local.engine_major_version}"
}

resource "aws_db_instance" "primary" {
  identifier                  = "${var.name}-primary-rds"
  db_name                     = var.database_name
  engine                      = var.engine
  engine_version              = var.engine_version
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately

  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  max_allocated_storage     = var.max_allocated_storage
  snapshot_identifier       = var.snapshot_identifier
  storage_encrypted         = var.encrypted
  kms_key_id                = var.kms_key_id
  deletion_protection       = var.deletion_protection
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-primary-rds-final-snapshot"
  skip_final_snapshot       = var.skip_final_snapshot

  multi_az               = var.multi_az
  port                   = local.port
  publicly_accessible    = false
  vpc_security_group_ids = concat(var.additional_security_group_ids, [aws_security_group.this.id])
  db_subnet_group_name   = aws_db_subnet_group.this.name
  option_group_name      = var.engine == "mysql" ? aws_db_option_group.this[0].name : null
  parameter_group_name   = aws_db_parameter_group.this.name

  username                            = var.auth_configuration.username
  password                            = var.auth_configuration.initial_password
  iam_database_authentication_enabled = var.auth_configuration.iam_database_authentication_enabled

  backup_retention_period         = var.automated_snapshot_retention_period
  maintenance_window              = var.maintenance_window
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval != 0 ? aws_iam_role.monitoring[0].arn : null
  enabled_cloudwatch_logs_exports = local.log_exports

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  tags                  = var.tags_all
  copy_tags_to_snapshot = true

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}

resource "aws_db_instance" "replicas" {
  for_each = var.read_replicas

  identifier                  = "${var.name}-${each.key}-replica-rds"
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately
  replicate_source_db         = aws_db_instance.primary.identifier

  instance_class        = each.value.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.encrypted
  kms_key_id            = var.kms_key_id
  deletion_protection   = each.value.deletion_protection

  multi_az               = each.value.multi_az
  port                   = local.port
  publicly_accessible    = false
  vpc_security_group_ids = concat(var.additional_security_group_ids, [aws_security_group.this.id])
  parameter_group_name   = aws_db_parameter_group.replicas[each.key].name

  iam_database_authentication_enabled = var.auth_configuration.iam_database_authentication_enabled

  backup_retention_period         = each.value.automated_snapshot_retention_period
  maintenance_window              = var.maintenance_window
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval != 0 ? aws_iam_role.monitoring[0].arn : null
  enabled_cloudwatch_logs_exports = local.log_exports
  skip_final_snapshot             = true

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  tags                  = var.tags_all
  copy_tags_to_snapshot = true
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-rds-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${var.name} database"

  tags = var.tags_all
}

resource "aws_db_option_group" "this" {
  count = var.engine == "mysql" ? 1 : 0

  name                 = "${var.name}-rds-option-group"
  engine_name          = var.engine
  major_engine_version = local.engine_major_version

  dynamic "option" {
    for_each = var.options
    content {
      option_name = option.key
      option_settings {
        name  = option.value.name
        value = option.value.value
      }
    }
  }
}

resource "aws_db_instance_role_association" "s3_import" {
  count                  = length(var.allowed_buckets_to_import) > 0 ? 1 : 0
  db_instance_identifier = aws_db_instance.primary.identifier
  feature_name           = "s3Import"
  role_arn               = aws_iam_role.db_s3_import[count.index].arn
}

resource "aws_db_instance_role_association" "s3_export" {
  count                  = length(var.allowed_buckets_to_export) > 0 ? 1 : 0
  db_instance_identifier = aws_db_instance.primary.identifier
  feature_name           = "s3Export"
  role_arn               = aws_iam_role.db_s3_export[count.index].arn
}
