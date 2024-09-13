resource "aws_network_interface" "this" {
  subnet_id         = var.subnet_id
  source_dest_check = false
  security_groups   = [aws_security_group.this.id]
  tags              = var.tags_all

  lifecycle {
    replace_triggered_by = [aws_security_group.this]
  }
}

resource "aws_eip" "public_ip" {
  network_interface = aws_network_interface.this.id
  domain            = "vpc"
  tags              = var.tags_all
}

resource "aws_autoscaling_group" "this" {
  name_prefix      = var.name_prefix
  desired_capacity = var.schedule_power_on_cron != "" || var.schedule_power_off_cron != "" ? null : 1
  max_size         = 1
  min_size         = 0

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

resource "aws_autoscaling_schedule" "power_on" {
  count                  = var.schedule_power_on_cron != "" ? 1 : 0
  scheduled_action_name  = "power-on"
  autoscaling_group_name = aws_autoscaling_group.this.name
  desired_capacity       = 1
  max_size               = 1
  min_size               = 1
  time_zone              = var.schedule_time_zone
  recurrence             = var.schedule_power_on_cron
}

resource "aws_autoscaling_schedule" "power_off" {
  count                  = var.schedule_power_off_cron != "" ? 1 : 0
  scheduled_action_name  = "power-off"
  autoscaling_group_name = aws_autoscaling_group.this.name
  desired_capacity       = 0
  max_size               = 1
  min_size               = 0
  time_zone              = var.schedule_time_zone
  recurrence             = var.schedule_power_off_cron
}
