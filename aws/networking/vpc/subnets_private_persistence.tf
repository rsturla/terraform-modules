resource "aws_subnet" "private_persistence" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = aws_vpc.this.id

  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block = lookup(
    var.private_persistence_subnet_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(var.cidr_block, var.private_persistence_subnet_bits, count.index + local.private_peristence_subnet_spacing),
  )
  ipv6_cidr_block = lookup(
    var.private_persistence_subnet_ipv6_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(aws_vpc.this.ipv6_cidr_block, var.ipv6_subnet_bits, count.index + local.private_peristence_subnet_spacing),
  )

  tags = merge(
    { Name = "${var.name}-private-persistence-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route_table" "private_persistence" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-private-persistence-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route" "private_persistence_nat" {
  count = var.allow_private_persistence_internet_access ? length(data.aws_availability_zones.all.names) : 0

  route_table_id         = element(aws_route_table.private_persistence.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.private_persistence,
  ]
}

resource "aws_route" "private_persistence_egress_only_internet_gateway" {
  count = var.allow_private_persistence_internet_access ? length(data.aws_availability_zones.all.names) : 0

  route_table_id              = aws_route_table.private_persistence[count.index].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_egress_only_internet_gateway.this.id

  depends_on = [
    aws_egress_only_internet_gateway.this,
    aws_route_table.private_persistence,
  ]
}

resource "aws_route_table_association" "private_persistence" {
  count = length(data.aws_availability_zones.all.names)

  subnet_id      = aws_subnet.private_persistence[count.index].id
  route_table_id = aws_route_table.private_persistence[count.index].id
}
