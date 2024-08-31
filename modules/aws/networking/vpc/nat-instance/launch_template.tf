data "aws_ami" "this" {
  most_recent = true
  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

locals {
  image_tags           = data.aws_ami.this.tags
  bootc_image_registry = lookup(local.image_tags, "bootc-image-registry", null)
}

resource "aws_network_interface" "this" {
  subnet_id         = var.subnet_id
  source_dest_check = false
  security_groups   = [aws_security_group.this.id]
  tags              = var.tags_all
}

resource "aws_eip" "public_ip" {
  network_interface = aws_network_interface.this.id
  domain            = "vpc"
  tags              = var.tags_all
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
