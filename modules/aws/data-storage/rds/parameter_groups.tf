locals {
  base_parameters = {
    "shared_preload_libraries" = {
      value        = "pg_stat_statements"
      apply_method = "pending-reboot"
    }

    # Enable SQL statements tracking
    "pg_stat_statements.track" = {
      value        = "all"
      apply_method = "immediate"
    }

    # Logging slow queries
    "log_min_duration_statement" = {
      value        = 5 * 1000 # ms
      apply_method = "immediate"
    }

    # Logging connection events
    "log_connections" = {
      value        = "1"
      apply_method = "immediate"
    }

    "log_disconnections" = {
      value        = "1"
      apply_method = "immediate"
    }

    # Set log level on the server side
    "log_min_messages" = {
      value        = "notice"
      apply_method = "immediate"
    }
  }

  base_replica_parameters = {
    "hot_standby_feedback" = {
      value        = 1
      apply_method = "immediate"
    }
    "max_standby_streaming_delay" = {
      value        = 12 * 60 * 60 * 1000 # 12 hours
      apply_method = "immediate"
    }
    "max_standby_archive_delay" = {
      value        = 12 * 60 * 60 * 1000 # 12 hours
      apply_method = "immediate"
    }
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-rds-parameter-group"
  family      = local.parameter_group_family
  description = "Parameter group for ${var.name} database"

  dynamic "parameter" {
    for_each = merge(
      local.base_parameters,
      var.parameters
    )

    content {
      name         = parameter.key
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags_all
}

resource "aws_db_parameter_group" "replicas" {
  for_each = var.read_replicas

  name        = "${var.name}-${each.key}-replica-rds-parameter-group"
  family      = local.parameter_group_family
  description = "Parameter group for ${var.name} ${each.key} replica database"

  dynamic "parameter" {
    for_each = merge(
      local.base_parameters,
      local.base_replica_parameters,
      each.value.parameters
    )

    content {
      name         = parameter.key
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags_all
}
