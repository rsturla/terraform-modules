output "dkim_tokens" {
  value = {
    "dkim_tokens" = concat(aws_sesv2_email_identity.this.dkim_signing_attributes[*].tokens...)
  }
}

output "arn" {
  value = aws_sesv2_email_identity.this.arn
}

output "identity_type" {
  value = aws_sesv2_email_identity.this.identity_type
}

output "configuration_set_arn" {
  value = aws_sesv2_configuration_set.this.arn
}
