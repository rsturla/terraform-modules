output "certificate_arns" {
  value = {
    for key, c in aws_acm_certificate.this :
    key => c.arn
  }
}

output "certificate_ids" {
  value = {
    for key, c in aws_acm_certificate.this :
    key => c.id
  }
}

output "certificate_domain_names" {
  value = {
    for key, c in aws_acm_certificate.this :
    key => c.domain_name
  }
}

output "certificate_validation_options" {
  value = {
    for key, c in aws_acm_certificate.this :
    key => c.domain_validation_options
  }
}
