resource "aws_subnet" "private_app" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block = lookup(
    var.private_app_subnet_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(var.cidr_block, var.private_app_subnet_bits, count.index + local.private_app_subnet_spacing)
  )

  enable_dns64                    = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = lookup(
    var.private_app_subnet_ipv6_cidr_blocks,
    "AZ-${count.index}",
    cidrsubnet(aws_vpc.this.ipv6_cidr_block, var.ipv6_subnet_bits, count.index + local.private_app_subnet_spacing)
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

resource "aws_route" "private_app_nat" {
  count = !local.is_nat_instance ? length(data.aws_availability_zones.all.names) : 0

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.private_app,
  ]
}

output "is_nat_instance" {
  value = local.is_nat_instance
}

resource "aws_route" "private_app_nat_instance" {
  count = local.is_nat_instance ? length(data.aws_availability_zones.all.names) : 0

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  network_interface_id = length(module.nat_instance.*.network_interface_id) > 0 ? element(module.nat_instance.*.network_interface_id, count.index) : ""

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.private_app,
  ]
}

resource "aws_route" "private_app_egress_only_internet_gateway" {
  count = length(data.aws_availability_zones.all.names)

  route_table_id              = aws_route_table.private_app[count.index].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this.id

  depends_on = [
    aws_egress_only_internet_gateway.this,
    aws_route_table.private_app,
  ]
}

resource "aws_route_table_association" "private_app" {
  count = length(data.aws_availability_zones.all.names)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}
