data "aws_prefix_list" "prefix_list" {
  count = var.allow_egress_to_managed_prefix_lists != null ? length(var.allow_egress_to_managed_prefix_lists) : 0

  name = var.allow_egress_to_managed_prefix_lists[count.index]
}

resource "aws_security_group" "this" {
  name        = "${var.name}-rds-sg"
  description = "Security group for ${var.name} database"
  vpc_id      = var.vpc_id

  tags = merge({
    Usage = "Internal",
  }, var.tags_all)
}

resource "aws_security_group_rule" "this_ingress_consumer" {
  security_group_id        = aws_security_group.this.id
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = aws_security_group.consumer.id
  description              = "Ingress for ${var.engine} on port ${local.port} from consumer security group"
}

resource "aws_security_group_rule" "this_ingress_cidr" {
  security_group_id = aws_security_group.this.id
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = var.allow_ingress_from_cidrs
  description       = "Ingress for ${var.engine} on port ${local.port} from CIDRs"
}

resource "aws_security_group_rule" "this_ingress_security_group" {
  for_each                 = toset(var.allow_ingress_from_security_groups)
  security_group_id        = aws_security_group.this.id
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = each.value
  description              = "Ingress for ${var.engine} on port ${local.port} from security group ${each.value}"
}

resource "aws_security_group_rule" "this_egress_all" {
  count             = length(var.allow_egress_to_cidrs) != 0 ? 1 : 0
  security_group_id = aws_security_group.this.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  type        = "egress"
  cidr_blocks = var.allow_egress_to_cidrs
  description = "Egress for ${var.engine} on port ${local.port} to CIDRs"
}

resource "aws_security_group_rule" "this_egress_managed_prefix_list" {
  count             = length(var.allow_egress_to_managed_prefix_lists) != 0 ? 1 : 0
  security_group_id = aws_security_group.this.id

  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  type            = "egress"
  prefix_list_ids = data.aws_prefix_list.prefix_list[*].id
  description     = "Egress for ${var.engine} on port ${local.port} to managed prefix lists"
}

resource "aws_security_group" "consumer" {
  name        = "${var.name}-rds-consumer-sg"
  description = "Security group for ${var.name} database consumers"
  vpc_id      = var.vpc_id
  tags        = var.tags_all
}
