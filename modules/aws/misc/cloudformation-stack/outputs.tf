output "cloudformation_stack_id" {
  value       = aws_cloudformation_stack.this.id
  description = "The ID of the created cloudformation stack"
}

output "cloudformation_stack_outputs" {
  value       = aws_cloudformation_stack.this.outputs
  description = "The outputs of the created cloudformation stack"
}
