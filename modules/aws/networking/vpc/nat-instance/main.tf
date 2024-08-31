resource "aws_autoscaling_group" "this" {
  name_prefix      = var.name_prefix
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  // Since a Network Interface cannot span multiple Availability Zones, we need to hard-code the Availability Zone
  availability_zones = [var.availability_zone]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
      max_healthy_percentage = 100
    }
  }

  dynamic "launch_template" {
    for_each = var.use_spot_instance ? [] : [0]

    content {
      id      = aws_launch_template.this.id
      version = aws_launch_template.this.latest_version
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_spot_instance ? [0] : []

    content {
      instances_distribution {
        on_demand_base_capacity  = 0
        spot_allocation_strategy = "lowest-price"
      }

      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.this.id
        }
      }
    }
  }
}
