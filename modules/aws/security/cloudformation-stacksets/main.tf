resource "aws_cloudformation_stack_set" "this" {
  name             = var.name
  description      = var.description
  capabilities     = var.capabilities
  permission_model = "SERVICE_MANAGED"

  template_body = var.template
  template_url  = var.template_url
  parameters    = var.parameters

  dynamic "auto_deployment" {
    for_each = var.auto_deployment_enabled ? [true] : []
    content {
      enabled = true
    }
  }

  tags = var.tags_all
}

resource "aws_cloudformation_stack_set_instance" "accounts" {
  count = length(var.target_accounts) > 0 ? 1 : 0

  stack_set_name = aws_cloudformation_stack_set.this.name

  deployment_targets {
    accounts = var.target_accounts
  }
}

resource "aws_cloudformation_stack_set_instance" "this" {
  count = length(var.target_org_units) > 0 ? 1 : 0

  stack_set_name = aws_cloudformation_stack_set.this.name

  deployment_targets {
    organizational_unit_ids = var.target_org_units
  }
}
