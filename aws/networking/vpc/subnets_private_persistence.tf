resource "aws_subnet" "private_persistence" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = aws_vpc.this.id

  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block = lookup(
    var.private_persistence_subnet_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(var.cidr_block, var.private_persistence_subnet_bits, count.index + var.private_persistence_spacing),
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
  count = length(data.aws_availability_zones.all.names)

  route_table_id         = element(aws_route_table.private_persistence.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.private_persistence,
  ]
}

resource "aws_route_table_association" "private_persistence" {
  count = length(data.aws_availability_zones.all.names)

  subnet_id      = aws_subnet.private_persistence[count.index].id
  route_table_id = aws_route_table.private_persistence[count.index].id
}
