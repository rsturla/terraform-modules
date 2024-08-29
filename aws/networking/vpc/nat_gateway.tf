resource "aws_eip" "nat" {
  count  = var.nat_gateway_count
  domain = "vpc"

  tags = merge(
    { Name = "${var.name}-nat-eip-${count.index}" },
    var.tags_all,
  )
}

resource "aws_nat_gateway" "nat" {
  count = var.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index % length(aws_subnet.public.*.id))

  tags = merge(
    { Name = "${var.name}-nat-${count.index}" },
    var.tags_all,
  )
}
