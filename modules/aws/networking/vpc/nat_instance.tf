module "nat_instance" {
  source = "./nat-instance"
  count  = var.nat_instance_count

  name_prefix       = "${var.name}-nat-instance-${data.aws_availability_zones.all.names[count.index]}"
  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.all.names, count.index)
  subnet_id         = element(aws_subnet.public.*.id, count.index)
  ami_id            = var.nat_instance_ami_id
  ami_name_pattern  = var.nat_instance_ami_name_pattern
  ami_owner         = var.nat_instance_ami_owner
  instance_type     = var.nat_instance_type

  schedule_time_zone      = var.nat_instance_schedule_time_zone
  schedule_power_on_cron  = var.nat_instance_schedule_power_on_cron
  schedule_power_off_cron = var.nat_instance_schedule_power_off_cron
}
