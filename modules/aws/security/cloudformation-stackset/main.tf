resource "aws_cloudformation_stack_set" "this" {
  name             = var.name
  description      = var.description
  capabilities     = var.capabilities
  permission_model = "SERVICE_MANAGED"

  template_body = var.template_body
  template_url  = var.template_url
  parameters    = var.parameters

  auto_deployment {
    enabled = true
  }

  tags = var.tags_all

  lifecycle {
    ignore_changes = [ administration_role_arn ]
  }
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
