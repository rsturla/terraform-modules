module "flow_log" {
  source = "../vpc-flow-logs"

  vpc_id = aws_vpc.this.id
  name   = "${var.name}-flow-logs"

  traffic_type                     = var.flow_log_traffic_type
  cloudwatch_log_retention_in_days = var.flow_log_cloudwatch_log_retention_in_days
}
