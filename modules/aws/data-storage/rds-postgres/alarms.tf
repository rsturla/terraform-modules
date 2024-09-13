locals {
  alarm_thresholds = {
    BurstBalanceThreshold     = var.alarm_thresholds.burst_balance_pct
    CPUUtilizationThreshold   = var.alarm_thresholds.cpu_utilization_pct
    CPUCreditBalanceThreshold = var.alarm_thresholds.cpu_credit_balance
    DiskQueueDepthThreshold   = var.alarm_thresholds.disk_queue_depth
    FreeStorageSpaceThreshold = var.allocated_storage * (var.alarm_thresholds.free_storage_space_pct / 100)
    FreeableMemoryThreshold   = var.alarm_thresholds.freeable_memory
    ReplicaLagTimeThreshold   = var.alarm_thresholds.replica_lag
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_burst_balance" {
  count = var.alarms_enabled && local.alarm_thresholds["BurstBalanceThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-burst-balance-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average database storage burst balance over last 10 minutes below ${local.alarm_thresholds["BurstBalanceThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_utilization" {
  count = var.alarms_enabled && local.alarm_thresholds["CPUUtilizationThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average database CPU utilization over last 10 minutes above ${local.alarm_thresholds["CPUUtilizationThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_credit_balance" {
  count = var.alarms_enabled && local.alarm_thresholds["CPUCreditBalanceThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-cpu-credit-balance-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["CPUCreditBalanceThreshold"]
  alarm_description   = "Average database CPU credit balance over last 10 minutes below ${local.alarm_thresholds["CPUCreditBalanceThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_disk_queue_depth" {
  count = var.alarms_enabled && local.alarm_thresholds["DiskQueueDepthThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-disk-queue-depth-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average database disk queue depth over last 10 minutes above ${local.alarm_thresholds["DiskQueueDepthThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_free_storage_space" {
  count = var.alarms_enabled && local.alarm_thresholds["FreeStorageSpaceThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-free-storage-space-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space over last 10 minutes below ${local.alarm_thresholds["FreeStorageSpaceThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_freeable_memory" {
  count = var.alarms_enabled && local.alarm_thresholds["FreeableMemoryThreshold"] != null ? 1 : 0

  alarm_name          = "${aws_db_instance.primary.identifier}-freeable-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60 * 10
  statistic           = "Average"
  threshold           = local.alarm_thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average database freeable memory over last 10 minutes below ${local.alarm_thresholds["FreeableMemoryThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.primary.identifier
  }

  tags = var.tags_all
}

resource "aws_cloudwatch_metric_alarm" "alarm_replica_lag_time" {
  for_each            = var.alarms_enabled && local.alarm_thresholds["ReplicaLagTimeThreshold"] != null ? aws_db_instance.replicas : {}
  alarm_name          = "${aws_db_instance.replicas[each.key].identifier}-lag-time-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Maximum"
  threshold           = local.alarm_thresholds["ReplicaLagTimeThreshold"]
  alarm_description   = "Database replication lag over last 5 minutes exceeded ${local.alarm_thresholds["ReplicaLagTimeThreshold"]}"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.replicas[each.key].identifier
  }

  tags = var.tags_all
}
