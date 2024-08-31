data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name_prefix = var.name_prefix

  tags = var.tags_all
}

// Allow ingress from the VPC CIDR block
resource "aws_security_group_rule" "ingress_vpc" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_vpc.this.cidr_block]
  ipv6_cidr_blocks  = [data.aws_vpc.this.ipv6_cidr_block]
}

// Allow all egress traffic to the internet
resource "aws_security_group_rule" "egress_internet" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
