resource "aws_autoscaling_group" "this" {
  name_prefix      = var.name_prefix
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  // Since a Network Interface cannot span multiple Availability Zones, we need to hard-code the Availability Zone
  availability_zones = [var.availability_zone]

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
}