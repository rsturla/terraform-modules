resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  tags         = var.tags_all
}

resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public[0].id
}

resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  count = var.create_vpc_endpoints ? length(data.aws_availability_zones.all.names) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.private_app[count.index].id
}

resource "aws_vpc_endpoint_route_table_association" "s3_persistence" {
  count = var.create_vpc_endpoints ? length(data.aws_availability_zones.all.names) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.private_persistence[count.index].id
}
