resource "aws_subnet" "private_app" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block = lookup(
    var.private_app_subnet_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(var.cidr_block, var.private_subnet_bits, count.index),
  )

  tags = merge(
    { Name = "${var.name}-private-app-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route_table" "private_app" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-private-app-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route" "nat" {
  count = length(data.aws_availability_zones.all.names)

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.private_app,
  ]
}

resource "aws_route_table_association" "private_app" {
  count = length(data.aws_availability_zones.all.names)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}
