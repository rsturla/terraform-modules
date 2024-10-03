resource "aws_cloudformation_stack" "this" {
  name               = var.name
  template_body      = var.template_body
  template_url       = var.template_url
  capabilities       = var.capabilities
  disable_rollback   = var.disable_rollback
  notification_arns  = var.notification_arns
  on_failure         = var.on_failure
  parameters         = var.parameters
  policy_body        = var.cloudformation_stack_policy_body
  policy_url         = var.cloudformation_stack_policy_url
  iam_role_arn       = aws_iam_role.cloudformation_stack_assume_role.arn
  timeout_in_minutes = var.timeout_in_minutes
  tags = merge(var.tags_all, {
    Name = var.name,
  })

  depends_on = [aws_iam_policy_attachment.additional_permissions_attachment]
}
