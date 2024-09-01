data "aws_ami" "this" {
  most_recent = true
  owners      = [var.ami_owner]

  dynamic "filter" {
    for_each = var.ami_id != null ? [0] : []
    content {
      name   = "image-id"
      values = [var.ami_id]
    }
  }

  dynamic "filter" {
    for_each = var.ami_name_pattern != null && var.ami_id == null ? [0] : []
    content {
      name   = "name"
      values = [var.ami_name_pattern]
    }
  }
}

resource "aws_launch_template" "this" {
  name_prefix            = var.name_prefix
  image_id               = data.aws_ami.this.id
  instance_type          = var.instance_type
  tags                   = var.tags_all
  update_default_version = true

  network_interfaces {
    device_index         = 0
    network_interface_id = aws_network_interface.this.id
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance.name
  }

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags_all,
      {
        Name = "${var.name_prefix}"
      }
    )
  }
}
