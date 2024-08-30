module "nat_instance" {
  source = "./nat-instance"
  count  = var.nat_instance_count

  name_prefix       = "${var.name}-${data.aws_availability_zones.all.names[count.index]}-nat-instance"
  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.all.names, count.index)
  subnet_id         = element(aws_subnet.public.*.id, count.index)
  ami_id            = "ami-082985da87b625807"
  instance_type     = var.nat_instance_type
}
