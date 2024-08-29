resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block = lookup(
    var.public_subnet_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(var.cidr_block, var.public_subnet_bits, count.index),
  )

  enable_dns64 = true
  ipv6_cidr_block = lookup(
    var.public_subnet_ipv6_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(aws_vpc.this.ipv6_cidr_block, var.ipv6_subnet_bits, count.index),
  )

  tags = merge(
    { Name = "${var.name}-public-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route_table" "public" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-public-${count.index}" },
    var.tags_all,
  )
}

resource "aws_route" "internet" {
  count = length(data.aws_availability_zones.all.names)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.public,
  ]
}

resource "aws_route" "ipv6_default_gateway" {
  count = length(data.aws_availability_zones.all.names)

  route_table_id              = aws_route_table.public[count.index].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this.id

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.public,
  ]
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.all.names)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}
